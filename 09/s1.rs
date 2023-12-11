fn main() {
    // this was cool and from https://github.com/chrismo80/advent_of_code/blob/default/src/year2023/day08/mod.rs
    let input: Vec<String> = include_str!("test.txt").split("\n").filter_map(|e| e.parse().ok()).collect();
    // println!("{:#?}...{}", input, input.first().unwrap());

    let first: Vec<usize> = input.first().unwrap().split(" ").filter_map(|e| e.parse::<usize>().ok()).collect();
    println!("{:#?}", first)

    // let instructions: Vec<char> = input.first().unwrap().chars().collect();

    // let network = input.last().unwrap().as_str();
    // let map = network.to_vec_from_regex(r"^(\w{3}) = \((\w{3})\, (\w{3})\)$");

    // let starts: Vec<&str> = map.iter().filter(|m| m[0].ends_with('A')).map(|m| m[0]).collect();
    // let distances: Vec<usize> = starts.iter().map(|start| escape(&map, &instructions, start, "Z")).collect();

    // let result1 = escape(&map, &instructions, "AAA", "ZZZ");
    // let result2 = distances.lcm();

    // println!("8\t{result1:<20}\t{result2:<20}");

    // (result1, result2)
}