import requests
from bs4 import BeautifulSoup
import urllib3
import time
urllib3.disable_warnings()
import json

# "https://www.ragnarokmobile.net/monsters?page=2" - Up to 15
# https://www.ragnarokmobile.net/monster/abysmal-knight

goodvales = [
"Level",
"Type",
"Zone",
"Race",
"Element",
"Size",
"Atk",
"MAtk",
"Def",
"MDef",
"Hp",
"Hit",
"Flee",
"Move Speed",
"Atk Speed",
"Base Exp",
"Job Exp",
"Wind",
"Fire",
"Water",
"Earth",
"Neutral",
"Holy",
"Shadow",
"Poison",
"Undead",
"Ghost"
]

allmondata = {}

for x in range(1, 16):
    rallmon = requests.get("https://www.ragnarokmobile.net/monsters?page=" + str(x), verify=False)
    soupallmon = BeautifulSoup(rallmon.text, 'lxml')
    if len(soupallmon.select("table.table tr")) > 0:
        for table_row in soupallmon.select("table.table tr"):
            cells = table_row.findAll('td')
            link = cells[0].a["href"].encode("utf-8")
            name = cells[1].text.rstrip()
            rsingle = requests.get(link, verify=False)
            soupsingle = BeautifulSoup(rsingle.text, 'lxml')
            if len(soupsingle.select("table.table tr")) > 0:
                for table_row in soupsingle.select("table.table tr"):
                    cells = table_row.findAll('td')
                    if cells[0].text in goodvales:
                        try:
                            if name not in allmondata:
                                allmondata[name] = []
                            allmondata[name].append({
                                str(cells[0].text): str(cells[1].text)
                            })
                            print(str(name) + " " + str(cells[0].text) + ": " + str(cells[1].text))
                        except:
                          print("An exception occurred")

with open('monsters.json', 'w') as outfile:
    json.dump(allmondata, outfile)
