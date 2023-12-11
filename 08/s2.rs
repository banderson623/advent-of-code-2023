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


fn multi_journey(map: &GhostMap, instructions: &String, locations: &LocationCollection, step:u32) -> LocationCollection {
  // https://stackoverflow.com/a/71824291/5419
  let relative_step = usize::try_from(step).unwrap() % instructions.as_bytes().len();
  let direction = instructions.chars().nth(relative_step).unwrap();

  // println!("I have locations {:#?}", locations);

  let mut next_locations: LocationCollection = LocationCollection::new();

  for location in locations.iter() {
    if let Some(location) = map.get(location) {
      let next_location: &String = if direction == 'L' {&location.0} else {&location.1};
      next_locations.push(next_location.to_string());
    }
  }

  // println!("at: {:#?} going {} to {:#?} (step: {})", locations, direction, next_locations, step);
  return next_locations;
}

type GhostMap = HashMap<String, LeftRight>;
type LocationCollection = Vec<String>;

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
  // let mut step:u32 = 0;
  let mut locations: LocationCollection = LocationCollection::new();

  for (location, _option) in map.iter() {
    if location.ends_with("A"){
      locations.push(location.to_string())
    }
  }

  println!("starting at {:#?}", locations);
  // println!("all end in z: {}", all_end_in_z(&locations));


  let mut step = 0;
  loop {
    let next_locations: LocationCollection = multi_journey(&map, &left_and_right_instructions, &locations, step);

    locations.clear();
    locations = next_locations;

    if all_end_in_z(&locations) {
      println!("all done, I took {} steps", step +1 );
      break();
    }
    step += 1;

    // println!("----------------");
    // if step > 5 {break()}
  }

}

fn all_end_in_z(locations: &LocationCollection) -> bool{
  if locations.is_empty() {return false}

  // println!("checking if these all end in Z {:#?}", locations);

  for location in locations.iter() {
    if !location.ends_with('Z') {
      return false
    }
  }

  return true;
}

// From: https://doc.rust-lang.org/rust-by-example/std_misc/file/read_lines.html
// The output is wrapped in a Result to allow matching on errors
// Returns an Iterator to the Reader of the lines of the file.
fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}