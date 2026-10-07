import csv
from pathlib import Path

input_folder = Path("FloridaArrest")
output_folder = Path("FloridaArrest_with_source")

output_folder.mkdir(exist_ok=True)

for file in input_folder.glob("*.csv"):

    output_file = output_folder / file.name

    with open(file, "r", newline="", encoding="utf-8-sig") as infile:
        reader = csv.DictReader(infile)
        fields = reader.fieldnames + ["source_file", "source_row"]

        with open(output_file, "w", newline="", encoding="utf-8-sig") as outfile:
            writer = csv.DictWriter(outfile, fieldnames=fields)
            writer.writeheader()

            for row_number, row in enumerate(reader, start=1):
                row["source_file"] = int(file.stem[-2:])
                row["source_row"] = row_number

                writer.writerow(row)

    print(f"Finished: {file.name}")
