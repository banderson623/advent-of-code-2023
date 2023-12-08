use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::collections::HashMap;

fn main() {
  println!("Day 8: Step 1");

  let filename = "./test.txt";
  let mut left_and_right_instructions = String::from("");
  let mut map: HashMap<String, String> = HashMap::new();

  // File hosts.txt must exist in the current path
  if let Ok(lines) = read_lines(filename) {
    // Consumes the iterator, returns an (Optional) String
    for line in lines {
      if let Ok(value) = line {

        // skip empty lines
        if value.len() == 0 { continue; }

        if left_and_right_instructions.len() == 0 {
          println!("let me read instructions from {}", value);
          left_and_right_instructions = value.clone();
        } else {
          let mut map_parts = value.split(" = ");
          let lookup = map_parts.next().unwrap();
          let directions = map_parts.next()
                                            .unwrap()
                                            .replace("(", "")
                                            .replace(")", "");

          map.insert(String::from(lookup), String::from(directions));
        }
      }
    }
  }

  println!("instructions: {}, map: {:#?}", left_and_right_instructions, map);

}

// From: https://doc.rust-lang.org/rust-by-example/std_misc/file/read_lines.html
// The output is wrapped in a Result to allow matching on errors
// Returns an Iterator to the Reader of the lines of the file.
fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}