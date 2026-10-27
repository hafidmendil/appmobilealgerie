import json

def clean(path):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    keys_to_delete = []
    for k, v in data.items():
        if '\n' in v or '"' in v or "'" in v:
            if k.startswith("auto_"):
                keys_to_delete.append(k)
    for k in keys_to_delete:
        del data[k]
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

clean('lib/l10n/app_fr.arb')
clean('lib/l10n/app_ar.arb')
print("Cleaned")
