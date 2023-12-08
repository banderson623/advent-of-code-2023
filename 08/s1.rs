use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::collections::HashMap;
use std::convert::TryFrom;

const FILENAME:&str = "./input.txt";

#[derive(Debug)]
struct LeftRight(String, String);

impl LeftRight {
  fn from(line:String) -> Self{
    let mut parts = line.split(", ");
    Self {
      0: parts.next().unwrap().to_string(),
      1: parts.next().unwrap().to_string()
    }
  }
}

fn recursive_journey(map: &GhostMap, instructions: &String, location: String, step:u32) -> u32 {
  // https://stackoverflow.com/a/71824291/5419
  let relative_step = usize::try_from(step).unwrap() % instructions.as_bytes().len();

  let direction = instructions.chars().nth(relative_step).unwrap();

  let options: &LeftRight = map.get(&location).unwrap();
  let next_location: &String = if direction == 'L' {&options.0} else {&options.1};

  // println!("at: {}, choices: {:#?} lets take a step {}, going {} which is {}", location, options, step, direction, next_location);
  println!("at: {} going to {}", location, next_location);

  if next_location != "ZZZ" {
    let nex_step = step + 1;
    return recursive_journey(&map, &instructions, next_location.to_string(), nex_step);
  } else {
    return step;
  }
}

fn journey(map: &GhostMap, instructions: &String, location: String, step:u32) -> String {
  // https://stackoverflow.com/a/71824291/5419
  let relative_step = usize::try_from(step).unwrap() % instructions.as_bytes().len();

  let direction = instructions.chars().nth(relative_step).unwrap();

  let options: &LeftRight = map.get(&location).unwrap();
  let next_location: &String = if direction == 'L' {&options.0} else {&options.1};

  println!("at: {} going {} to {} (step: {})", location, direction, next_location, step);

  return next_location.to_string();
}

type GhostMap = HashMap<String, LeftRight>;

fn main() {
  println!("Day 8: Step 1");

  let mut left_and_right_instructions = String::from("");
  let mut map: GhostMap = GhostMap::new();

  if let Ok(lines) = read_lines(FILENAME) {
    for line in lines {
      if let Ok(value) = line {

        // skip empty lines
        if value.len() == 0 { continue; }

        println!("{}", value);

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



          map.insert(String::from(lookup), LeftRight::from(directions));

        }
      }
    }
  }

  // println!("instructions: {}, map: {:#?}", left_and_right_instructions, map);
  // println!("All done, i took {} step(s)", recursive_journey(&map, &left_and_right_instructions, "AAA".to_string(), 0) + 1 )

  let mut step:u32 = 0;
  let mut location: String = "AAA".to_string();
  loop {
    location = journey(&map, &left_and_right_instructions, location, step);
    if location == "ZZZ" {
      println!("all done, I took {} steps", step +1 );
      break()
    }
    step += 1;
  }

}

// From: https://doc.rust-lang.org/rust-by-example/std_misc/file/read_lines.html
// The output is wrapped in a Result to allow matching on errors
// Returns an Iterator to the Reader of the lines of the file.
fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}