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

fn journey(map: &GhostMap, instructions: &String, location: String, step:usize) -> String {
  // https://stackoverflow.com/a/71824291/5419
  let relative_step = usize::try_from(step).unwrap() % instructions.as_bytes().len();

  let direction = instructions.chars().nth(relative_step).unwrap();

  let options: &LeftRight = map.get(&location).unwrap();
  let next_location: &String = if direction == 'L' {&options.0} else {&options.1};

  // println!("at: {} going {} to {} (step: {})", location, direction, next_location, step);

  return next_location.to_string();
}

type GhostMap = HashMap<String, LeftRight>;

fn main() {
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



  let mut locations: Vec<String> = Vec::new();

  for (location, _option) in map.iter() {
    if location.ends_with("A"){
      locations.push(location.to_string())
    }
  }

  let mut jouney_count = 0;
  let mut number_of_steps: [usize; 6] = [0,0,0,0,0,0];

  for starting_location in locations.iter() {
    let mut location = starting_location.to_string();
    let mut step:usize = 0;
    // let mut location: String = "TDA".to_string();
    loop {
      location = journey(&map, &left_and_right_instructions, location, step);
      if location.ends_with("Z") {
        let human_step_count: usize = step + 1;
        println!("{} took {} steps",location, human_step_count );
        number_of_steps[jouney_count] = human_step_count;
        jouney_count += 1;
        break();
      }
      step += 1;
    }
  }
  println!("getting total step counts... {:#?}", number_of_steps);
  println!("total step count: {} (from lcm)", lcm(&number_of_steps));
}

// From: https://doc.rust-lang.org/rust-by-example/std_misc/file/read_lines.html
// The output is wrapped in a Result to allow matching on errors
// Returns an Iterator to the Reader of the lines of the file.
fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

// From https://github.com/TheAlgorithms/Rust/blob/master/src/math/lcm_of_n_numbers.rs
pub fn lcm(nums: &[usize]) -> usize {
  if nums.len() == 1 {
      return nums[0];
  }
  let a = nums[0];
  let b = lcm(&nums[1..]);
  a * b / gcd_of_two_numbers(a, b)
}

fn gcd_of_two_numbers(a: usize, b: usize) -> usize {
  if b == 0 {
      return a;
  }
  gcd_of_two_numbers(b, a % b)
}

