fn diff_between(numbers: &Vec<i32>) -> Vec<i32> {
    if numbers.len() == 0 {return Vec::new()};

    let mut deltas: Vec<i32> = Vec::new();
    let mut last = numbers.first();

    for num in numbers.iter().skip(1) {
        deltas.push(num - last.unwrap_or(&0));
        last = Some(num);
    }
    return deltas;
}

fn get_next_value(numbers: &Vec<i32>) -> i32 {
    return numbers.last().unwrap() + get_diff_based_next(numbers);
}

fn get_diff_based_next(numbers: &Vec<i32>) -> i32 {
    let diffs = diff_between(numbers);
    let is_all_zeros = numbers.iter().all(|x| x.to_owned() == 0);
    if is_all_zeros { return 0 }
    return diffs.last().unwrap() + get_diff_based_next(&diffs);
}

fn main() {
    // this was cool and from https://github.com/chrismo80/advent_of_code/blob/default/src/year2023/day08/mod.rs
    let input: Vec<String> = include_str!("input.txt").split("\n").filter_map(|e| e.parse().ok()).collect();
    let mut sum_of_nexts = 0;

    for line in input.iter() {
        let numbers: Vec<i32> = line.split(" ").filter_map(|e| e.parse::<i32>().ok()).collect();
        let next_value = get_next_value(&numbers);
        sum_of_nexts += next_value;
        println!("next value: {}", next_value);
    }
    println!("sum of nexts is: {}", sum_of_nexts);
}