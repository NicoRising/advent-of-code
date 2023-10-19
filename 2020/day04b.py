import re

def main():
    lines = open('input.txt', 'r').read().splitlines()
    passports = ['']
    for line in lines:
        if not line:
            passports.append('')
        else:
            passports[-1] += line + ' '
    count = 0
    for passport in passports:
        if passport.count(':') == 8 or passport.count(':') == 7 and 'cid:' not in passport:
            fields = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']
            values = []
            for field in fields:
                index = passport.index(field)
                values.append(passport[index + 4:passport.index(' ', index)])
            if 1920 <= int(values[0]) <= 2002:
                if 2010 <= int(values[1]) <= 2020:
                    if 2020 <= int(values[2]) <= 2030:
                        if values[3][-2:] == 'cm' and 150 <= int(values[3][:-2]) <= 193 or values[3][-2:] == 'in' and 59 <= int(values[3][:-2]) <= 76:
                            if re.match('^#[\da-f]*$', values[4]):
                                if re.match('^(amb|blu|brn|gry|grn|hzl|oth)$', values[5]):
                                    if re.match('^\d{9}$', values[6]):
                                        count += 1
    print(count)

if __name__ == '__main__':
    main()