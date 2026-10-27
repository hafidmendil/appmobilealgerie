import json

wilayas = [
    ("01", "Adrar"), ("02", "Chlef"), ("03", "Laghouat"), ("04", "Oum El Bouaghi"),
    ("05", "Batna"), ("06", "Béjaïa"), ("07", "Biskra"), ("08", "Béchar"),
    ("09", "Blida"), ("10", "Bouira"), ("11", "Tamanrasset"), ("12", "Tébessa"),
    ("13", "Tlemcen"), ("14", "Tiaret"), ("15", "Tizi Ouzou"), ("16", "Alger"),
    ("17", "Djelfa"), ("18", "Jijel"), ("19", "Sétif"), ("20", "Saïda"),
    ("21", "Skikda"), ("22", "Sidi Bel Abbès"), ("23", "Annaba"), ("24", "Guelma"),
    ("25", "Constantine"), ("26", "Médéa"), ("27", "Mostaganem"), ("28", "M'Sila"),
    ("29", "Mascara"), ("30", "Ouargla"), ("31", "Oran"), ("32", "El Bayadh"),
    ("33", "Illizi"), ("34", "Bordj Bou Arreridj"), ("35", "Boumerdès"), ("36", "El Tarf"),
    ("37", "Tindouf"), ("38", "Tissemsilt"), ("39", "El Oued"), ("40", "Khenchela"),
    ("41", "Souk Ahras"), ("42", "Tipaza"), ("43", "Mila"), ("44", "Aïn Defla"),
    ("45", "Naâma"), ("46", "Aïn Témouchent"), ("47", "Ghardaïa"), ("48", "Relizane"),
    ("49", "El M'Ghair"), ("50", "El Meniaâ"), ("51", "Ouled Djellal"), ("52", "Bordj Badji Mokhtar"),
    ("53", "Béni Abbès"), ("54", "Timimoun"), ("55", "Touggourt"), ("56", "Djanet"),
    ("57", "In Salah"), ("58", "In Guezzam")
]

first_names = ["Amine", "Karim", "Omar", "Yassine", "Sarah", "Nadia", "Selma", "Layla", "Farid", "Mourad", "Samia", "Ines", "Ryad", "Mehdi", "Anis", "Lynda", "Myriam", "Sofiane", "Walid", "Zaki"]
last_names = ["Rahmani", "Mansouri", "Belkaid", "Zidani", "Khelifi", "Touati", "Lamine", "Bensalem", "Moussaoui", "Haddad", "Amrani", "Bouaziz", "Chabane", "Daoud", "Slimani", "Yacef", "Zerrouki", "Merah", "Ghalem", "Hamidi"]

accounts = []
counter = 1
for code, name in wilayas:
    for i in range(4):
        f_name = first_names[(counter - 1) % len(first_names)]
        l_name = last_names[(counter - 1) % len(last_names)]
        email = f"dr.{l_name.lower()}.{code}@neurosync.dz"
        phone = f"0{5+ (counter % 3)}{counter % 1000000:07d}"
        accounts.append({
            "id": counter,
            "fullName": f"Dr. {f_name} {l_name}",
            "email": email,
            "wilaya": name,
            "wilayaCode": code,
            "phone": phone
        })
        counter += 1

print("| ID | Nom Complet | Email | Wilaya | Téléphone |")
print("|---|---|---|---|---|")
for acc in accounts:
    print(f"| {acc['id']} | {acc['fullName']} | {acc['email']} | {acc['wilaya']} ({acc['wilayaCode']}) | {acc['phone']} |")
