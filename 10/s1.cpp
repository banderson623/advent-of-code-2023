// reading a text file
#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

int main()
{
  string line;
  ifstream myfile("./test.txt");

  vector< vector<string> > rows_columns;
  vector<string> column;

  if(!myfile.is_open()) { std::cout << "Unable to open file ... "; exit(-1);}

  while(getline(myfile, line)){
    cout << line << '\n';
    for(size_t i = 0; i < line.length(); i++) {
      column.push_back(line.substr(i, 1));
    }
    rows_columns.push_back(column);
  }
  myfile.close();

  return 0;
}