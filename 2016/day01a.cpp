#include <fstream>
#include <iostream>
#include <string>

using namespace std;

void main() {
    ifstream file{"input.txt"};
    string input;
    getline(file, input);
    input += ',';
    int x = 0;
    int y = 0;
    int facing = 0;
    string moveString = "";
    for (int i = 0; i < input.length(); i++) {
        if (input[i] == 'R') {
            if (++facing == 4) {
                facing = 0;
            }
        } else if (input[i] == 'L') {
            if (--facing == -1) {
                facing = 3;
            }
        } else if (input[i] != ' ') {
            if (input[i] == ',') {
                int moves = stoi(moveString);
                switch (facing) {
                    case 0:
                        y += moves;
                        break;
                    case 1:
                        x += moves;
                        break;
                    case 2:
                        y -= moves;
                        break;
                    case 3:
                        x -= moves;
                }
                moveString = "";
            } else {
                moveString += input[i];
            }
        }
    }
    cout << abs(x) + abs(y) << '\n';
    return 0;
}