def evaluate(expression):
    terms = []
    operators = []
    depth = 0
    capture = ''
    for char in expression:
        if depth > 0:
            capture += char
        if char == '(':
            depth += 1
        elif char == ')':
            depth -= 1
            if depth == 0:
                terms.append(evaluate(capture[: - 1]))
                capture = ''
        elif depth == 0:
            if char == '*' or char == '+':
                operators.append(char)
            else:
                terms.append(int(char))
    while len(terms) > 1:
        term = terms.pop(0)
        operator = operators.pop(0)
        if operator == '*':
            terms[0] = term * terms[0]
        else:
            terms[0] = term + terms[0]
    return terms[0]

def main():
    lines = open('input.txt','r').read().splitlines()
    total = 0
    for line in lines:
        total += evaluate(line.replace(' ', ''))
    print(total)
        
if __name__ == '__main__':
    main()