import os
import re
import json

fr_arb_path = 'lib/l10n/app_fr.arb'
ar_arb_path = 'lib/l10n/app_ar.arb'

def load_json(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_json(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

fr_data = load_json(fr_arb_path)
ar_data = load_json(ar_arb_path)

def generate_key(text):
    text = re.sub(r'[^a-zA-Z0-9\s]', '', text)
    words = [w.lower() for w in text.split() if len(w) > 2][:4]
    if not words:
        words = ["auto", "text", str(abs(hash(text)) % 1000)]
    return "_".join(words)

features_dir = 'lib/features'
changed_files = []
new_keys_count = 0

for root, _, files in os.walk(features_dir):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Find Text('...') or Text("...") without variables (no $)
            matches = re.finditer(r"Text\(\s*['\"]([^$]+?)['\"]\s*\)", content)
            
            new_content = content
            needs_import = False
            
            for match in matches:
                full_match = match.group(0)
                text = match.group(1)
                
                # Skip strings that look like codes, paths, or are very short
                if len(text) < 2 or re.match(r'^[A-Z0-9_]+$', text) or "/" in text:
                    continue
                    
                key = "auto_" + generate_key(text)
                # Ensure unique key
                original_key = key
                counter = 1
                while key in fr_data and fr_data[key] != text:
                    key = f"{original_key}_{counter}"
                    counter += 1
                
                fr_data[key] = text
                # We put a placeholder for Arabic to be translated later, or just the same text for now
                if key not in ar_data:
                    ar_data[key] = f"[AR] {text}"
                    new_keys_count += 1
                
                # Replace in dart
                replacement = f"Text(context.l10n.{key})"
                new_content = new_content.replace(full_match, replacement)
                needs_import = True
                
                # If there was a const before Text, remove it
                new_content = new_content.replace(f"const Text(context.l10n.{key})", f"Text(context.l10n.{key})")
            
            if needs_import and content != new_content:
                # Add import if missing
                if "l10n_extension.dart" not in new_content:
                    depth = filepath.count('/') - 1
                    rel_path = "../" * depth + "core/localization/l10n_extension.dart"
                    new_content = f"import '{rel_path}';\n" + new_content
                
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                changed_files.append(filepath)

if new_keys_count > 0:
    save_json(fr_arb_path, fr_data)
    save_json(ar_arb_path, ar_data)

print(f"Processed {len(changed_files)} files. Added {new_keys_count} keys.")
