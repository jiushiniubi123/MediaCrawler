import json
import re

# Load SMAPI data
with open('/tmp/smapi_mods.json', 'r') as f:
    smapi_data = json.load(f)

print(f"Loaded {len(smapi_data)} mods from SMAPI compatibility list")

# User's mod IDs
target_ids = [
    45541, 43920, 43236, 41869, 41832, 40812, 45590, 45374, 45492,
    45258, 45234, 45195, 45191, 45154, 45149, 45116, 45094, 45010,
    45013, 44963, 44958, 44953, 44848, 44710, 44580, 44339, 44245,
    44199, 44170, 44154, 44130, 44119, 44116, 44100, 44080, 43972,
    43803, 43670, 43668, 43594, 43136, 43127, 43105, 43023, 43035,
    42910, 42680, 42667, 42625, 42554, 42367, 42217, 41945, 41694,
    41650, 41648, 41503, 41499, 40902, 45620, 45594, 45572, 45532,
    45458, 45404, 45211, 45283, 45271, 45108, 44120, 45088, 45086,
    45082, 45081, 45007, 44682, 44652, 44639, 44622, 44039, 44383,
    44348, 44330, 44285, 44189, 44152, 43527, 44098, 43202, 44000,
    43978, 43234, 43966, 43962, 43937, 43893, 43762, 43512, 43558,
    43484, 43454, 43392, 43103, 43187, 43034, 43027, 43007, 42911,
    42853, 42858, 42868, 42846, 42016, 41883, 41843, 41856, 41505,
    41401, 41215, 41289, 41291, 41180, 41161, 41095, 41031, 40935,
    40992, 40889, 40887, 40885, 40808, 40847, 40811, 40771, 40744,
    40733
]

print(f"Target mods: {len(target_ids)}")

# Match mods by Nexus Mods ID
def extract_nexus_id(mod_pages):
    for page in mod_pages:
        url = page.get('Url', '')
        m = re.search(r'/mods/(\d+)', url)
        if m:
            return int(m.group(1))
    return None

# Build lookup by nexus ID
nexus_lookup = {}
for mod in smapi_data:
    nid = extract_nexus_id(mod.get('ModPages', []))
    if nid:
        nexus_lookup[nid] = mod

# Match target IDs
found = []
not_found = []
for tid in target_ids:
    if tid in nexus_lookup:
        found.append((tid, nexus_lookup[tid]))
    else:
        not_found.append(tid)

print(f"Found: {len(found)}, Not found: {len(not_found)}")

# Generate report
report = []
for tid, mod in found:
    name = mod.get('Name', 'Unknown')
    author = mod.get('Author', 'Unknown')
    alt_names = mod.get('AlternateNames', '')
    compat = mod.get('Compatibility', {})
    status = compat.get('Status', 'unknown')
    summary = compat.get('Summary', '')
    unofficial = compat.get('UnofficialVersion', '')
    broke_in = mod.get('BrokeIn', '')
    
    # Get mod pages
    pages = mod.get('ModPages', [])
    nexus_url = f"https://www.nexusmods.com/stardewvalley/mods/{tid}"
    
    source_url = mod.get('SourceUrl', '')
    warnings = mod.get('Warnings', [])
    
    report.append({
        'id': tid,
        'name': name,
        'author': author,
        'alt_names': alt_names,
        'status': status,
        'summary': summary,
        'unofficial_version': unofficial,
        'broke_in': broke_in,
        'warnings': warnings,
        'source_url': source_url,
        'nexus_url': nexus_url
    })

# Write detailed report
with open('/workspace/sdv_mods_report.json', 'w', encoding='utf-8') as f:
    json.dump({
        'total_target': len(target_ids),
        'found': len(found),
        'not_found': not_found,
        'mods': report
    }, f, indent=2, ensure_ascii=False)

print("\n=== Report written to sdv_mods_report.json ===")
print(f"\nNot found IDs: {not_found}")

# Print summary
print("\n=== STATUS SUMMARY ===")
status_counts = {}
for r in report:
    s = r['status']
    status_counts[s] = status_counts.get(s, 0) + 1
for s, c in sorted(status_counts.items()):
    print(f"  {s}: {c}")

print("\n=== FIRST 10 MODS ===")
for r in report[:10]:
    print(f"\n  [{r['id']}] {r['name']}")
    print(f"    Author: {r['author']}")
    print(f"    Status: {r['status']} - {r['summary'][:100]}")
    if r['warnings']:
        print(f"    Warnings: {r['warnings']}")
    if r['broke_in']:
        print(f"    Broke in: {r['broke_in']}")