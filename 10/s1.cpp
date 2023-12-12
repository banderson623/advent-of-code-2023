// reading a text file
#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

string PipeTurns[] = {"L", "J", "7", "F", "|", "S"};

enum Direction {North, East, South, West};
static const char* DirectionLabels[] = { "N", "E", "S", "W" };


class Pipe {
  private:
    string character;

  public:
    Pipe* north;
    Pipe* east;
    Pipe* south;
    Pipe* west;
    int col;
    int row;
    Direction possibleDirections[4];// = { -1,-1,-1,-1 };

  Pipe();
  Pipe(string ch, int row, int col);
  void computeDirections();
  bool isHole();
  string debug();
};

Pipe::Pipe() {
  character = "_";
  row = 0;
  col = 0;
}

Pipe::Pipe(string ch, int incoming_row, int incoming_col) {
  character = ch;
  row = incoming_row;
  col = incoming_col;
  this->computeDirections();
}

void Pipe::computeDirections() {
  possibleDirections = {-1,-1,-1,-1};
  if(character == "L") {
    possibleDirections[0] = North;
    possibleDirections[1] = East;
  } else if(character == "J") {
    possibleDirections[0] = North;
    possibleDirections[1] = West;
  } else if(character == "7") {
    possibleDirections[0] = South;
    possibleDirections[1] = West;
  } else if(character == "F") {
    possibleDirections[0] = South;
    possibleDirections[1] = East;
  } else if(character == "|") {
    possibleDirections[0] = North;
    possibleDirections[1] = South;
  } else if(character == "S") {
    possibleDirections[0] = East;
    possibleDirections[1] = West;
    possibleDirections[2] = North;
    possibleDirections[3] = South;
  }
}

bool Pipe::isHole() {
  return character == "S";
}

string Pipe::debug() {
  string directionDebug = "";
  for(size_t i = 0; i < 4; i++) {
    int direction = possibleDirections[i];
    if(direction > -1) {
      directionDebug += DirectionLabels[direction];
    }
  }

  string output = "Pipe: [" + character + "]" + " row: " + to_string(row) + " col: " + to_string(col) + " (" + directionDebug + ")";
  return output;
}

int main() {
  string line;
  ifstream myfile("./test.txt");

  vector< vector<string> > rows_columns;
  vector<Pipe> pipes;

  if(!myfile.is_open()) { std::cout << "Unable to open file ... "; exit(-1);}

  int row = 0;

  while(getline(myfile, line)){
    cout << line << "\n";
    vector<string> column;
    for(size_t i = 0; i < line.length(); i++) {
      string ch = line.substr(i, 1);
      if(std::find(std::begin(PipeTurns), std::end(PipeTurns), ch) != std::end(PipeTurns)) {
        pipes.push_back(Pipe(ch, row, i));
      }
      column.push_back(ch);
    }
    row++;
    rows_columns.push_back(column);
  }
  myfile.close();

  // iraterate through the pipes and print them
  for(size_t i = 0; i < pipes.size(); i++) {
    cout << pipes[i].debug() << endl;
  }

  // let's connect all the pipes
  Pipe startingHole;

  for(size_t i = 0; i < pipes.size(); i++) {
    Pipe pipe = pipes[i];
    if(pipe.isHole()) {
      startingHole = pipe;
      cout << "Found starting hole at: " << pipe.row << " " << pipe.col << endl;
    }


  }

  cout << startingHole.debug() << endl;
  return 0;
}
