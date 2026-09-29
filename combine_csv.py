import csv
from pathlib import Path

input_folder = Path("FloridaArrest_with_source")
output_file = Path("combined_fdle_with_source.csv")

csv_files = list(input_folder.glob("*.csv"))

with open(output_file, "w", newline="", encoding="utf-8-sig") as outfile:
    writer = None

    for file in csv_files:
        with open(file, "r", newline="", encoding="utf-8-sig") as infile:
            reader = csv.DictReader(infile)

            if writer is None:
                writer = csv.DictWriter(outfile, fieldnames=reader.fieldnames)
                writer.writeheader()

            for row in reader:
                writer.writerow(row)

        print(f"Added: {file.name}")

print("Done.")
