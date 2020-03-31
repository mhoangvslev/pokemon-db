import csv
import re
import unicodedata

RAW_CSV_PATH = '../dataset/raw/'
OUT_CSV_PATH = '../dataset/clean/'

EMPTY_CHAR = ''

def normalize_name(name):
    # Remove non-word char
    name = re.sub(r"[^a-zA-Z0-9_]", "", name)
    # Remove accents
    name = ''.join((c for c in unicodedata.normalize('NFD', name) if unicodedata.category(c) != 'Mn'))
    # Lowercase
    name = name.lower()
    return name


if __name__ == "__main__":

    csv_name = 'vgsales.csv'

    with open(RAW_CSV_PATH + csv_name) as csvfile:
        next(csvfile)
        readCSV = csv.reader(csvfile, delimiter=',')
        f = open(OUT_CSV_PATH + csv_name, "w")
        f.write("ID_GAME;GAME;ID_PLATFORM;YEAR_RELEASE;GENRE;ID_PUBLISHER;PUBLISHER;NA_SALES;EU_SALES;JP_SALES;"
                "OTHER_SALES;GLOBAL_SALES;CRITIC_SCORE;CRITIC_COUNT;ID_DEVELOPPER;DEVELOPPER;RATING\n")
        for row in readCSV:
            for i, cell in enumerate(row):
                if i == 0:  # ID_GAME ; GAME
                    f.write(normalize_name(cell) + ";")
                    f.write(cell.replace(';', ','))
                    f.write(";")
                elif i == 1:  # PLATFORM
                    f.write(cell.replace(';', ','))
                    f.write(";")
                elif i == 2:  # YEAR_RELEASE
                    if re.match(r'\d+', cell):
                        f.write('01/01/'+cell)
                    else:
                        f.write(EMPTY_CHAR)
                    f.write(";")
                elif i == 3:  # GENRE
                    f.write(cell)
                    f.write(";")
                elif i == 4:  # ID_PUBLISHER ; PUBLISHER
                    f.write(normalize_name(cell) + ";")
                    f.write(cell.replace(';', ','))
                    f.write(";")
                elif 5 <= i <= 9:  # ...SALES
                    try:
                        count = float(cell)
                        f.write(str(round(count * 1000000)))
                    except:
                        f.write(EMPTY_CHAR)
                    f.write(";")
                elif 10 <= i <= 11:  # CRITIC_SCORE ; CRITIC_COUNT
                    try:
                        count = int(cell)
                        f.write(str(count))
                    except:
                        f.write(EMPTY_CHAR)
                    f.write(";")
                elif i == 14:  # ID_DEVELOPPER ; DEVELOPPER
                    if cell:
                        f.write(normalize_name(cell) + ";")
                        f.write(cell.replace(';', ','))
                    else:
                        f.write(EMPTY_CHAR+';'+EMPTY_CHAR)
                    f.write(";")
                elif i == 15:  # RATING
                    if cell: f.write(cell)
                    else: f.write(EMPTY_CHAR)
            f.write("\n")
        f.close()

        csv_name = 'publisher.csv'

        with open(RAW_CSV_PATH + csv_name, errors='ignore') as csvfile:
            next(csvfile)
            readCSV = csv.reader(csvfile, delimiter=',')
            f = open(OUT_CSV_PATH + csv_name, "w")
            f.write("ID_PUBLISHER;PUBLISHER;HEADQUARTERS_COUNTRY;HEADQUARTERS_CITY;CREATION_DATE;NOTES\n")
            for row in readCSV:
                for i, cell in enumerate(row):
                    if i == 0:  # ID_PUBLISHER ; PUBLISHER
                        f.write(normalize_name(cell) + ";")
                        f.write(cell.replace(';', ','))
                        f.write(";")
                    elif i == 1:  # HEADQUARTERS_COUNTRY ; HEADQUARTERS_CITY
                        words = cell.split(',')
                        if len(words) == 1:
                            f.write(words[0].strip() + ';;')
                        elif len(words) > 1:
                            f.write(words[-1].strip() + ';')
                            f.write(words[0].strip() + ';')
                        else :
                            f.write(';;')
                    elif i == 2:  # CREATION_DATE
                        f.write('01/01/' + cell)
                        f.write(";")
                    elif i == 4:  # NOTES
                        f.write('"' + cell + '"')
                f.write("\n")
            f.close()

            csv_name = 'developper.csv'

            with open(RAW_CSV_PATH + csv_name, errors='ignore') as csvfile:
                next(csvfile)
                readCSV = csv.reader(csvfile, delimiter=',')
                f = open(OUT_CSV_PATH + csv_name, "w")
                f.write("ID_DEVELOPPER;DEVELOPPER;ACTIVE;HEADQUARTERS_CITY;HEADQUARTERS_COUNTRY;CREATION_DATE;NOTES\n")
                for row in readCSV:
                    for i, cell in enumerate(row):
                        if i == 0:  # ID_DEVELOPPER; DEVELOPPER
                            cell = cell.split(',')[-1]
                            cell = cell.strip()
                            f.write(normalize_name(cell) + ";")
                            f.write(cell.replace(';', ','))
                            f.write(";")
                        elif i == 1:  # ACTIVE;
                            f.write(cell)
                            f.write(';')
                        elif i == 2:  # HEADQUARTERS_CITY
                            f.write(cell.split(',')[0])
                            f.write(';')
                        elif i == 4:  # HEADQUARTERS_COUNTRY
                            if cell == 'US':
                                cell = 'United States'
                            elif cell == 'England' or cell == 'Scotland':
                                cell = 'UK'
                            elif cell == 'Netherlands':
                                cell = 'The Netherlands'
                            f.write(cell)
                            f.write(';')
                        elif i == 5:  # CREATION_DATE
                            if cell:
                                f.write('01/01/' + cell)
                            f.write(";")
                        elif i == 7:  # NOTES
                            f.write('"' + cell + '"')
                    f.write("\n")
                f.close()

            csv_name = 'plateform.csv'

            with open(RAW_CSV_PATH + csv_name, errors='ignore') as csvfile:
                next(csvfile)
                readCSV = csv.reader(csvfile, delimiter=',')
                f = open(OUT_CSV_PATH + csv_name, "w")
                f.write("PLATFORM;DEVELOPPER;MANUFACTURER;GAMES_COUNT;EU_RELEASE;USA_RELEASE;JP_RELEASE;GENERATION\n")
                for row in readCSV:
                    for i, cell in enumerate(row):
                        if (i < 7):
                            f.write(cell + ';')
                        else:
                            f.write(cell)
                    f.write("\n")
                f.close()


