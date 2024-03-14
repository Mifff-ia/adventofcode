pub fn answer1(input: &str) -> i64 {
    let map = parse(input);
    let (horizontal_empty, vertical_empty) = find_empty_lines(&map);
    let galaxies = find_galaxies(&map);
    (0..galaxies.len())
        .into_iter()
        .enumerate()
        .flat_map(|(ind, x)| ((x + 1)..galaxies.len()).into_iter().map(move |y| (ind, y)))
        .map(|(idx1, idx2)| {
            galaxy_length(
                galaxies[idx1],
                galaxies[idx2],
                (&horizontal_empty, &vertical_empty),
                2,
            )
        })
        .sum::<usize>() as i64
}

pub fn answer2(input: &str) -> i64 {
    let map = parse(input);
    let (horizontal_empty, vertical_empty) = find_empty_lines(&map);
    let galaxies = find_galaxies(&map);
    (0..galaxies.len())
        .into_iter()
        .enumerate()
        .flat_map(|(ind, x)| ((x + 1)..galaxies.len()).into_iter().map(move |y| (ind, y)))
        .map(|(idx1, idx2)| {
            galaxy_length(
                galaxies[idx1],
                galaxies[idx2],
                (&horizontal_empty, &vertical_empty),
                1000000,
            )
        })
        .sum::<usize>() as i64
}

fn galaxy_length(
    (x1, y1): (usize, usize),
    (x2, y2): (usize, usize),
    expansions: (&Vec<usize>, &Vec<usize>),
    expansion_length: usize,
) -> usize {
    let (xmin, xmax) = (x1.min(x2), x1.max(x2));
    let (ymin, ymax) = (y1.min(y2), y1.max(y2));
    xmax - xmin
        + expansions
            .0
            .iter()
            .filter(|x| xmin < **x && **x < xmax)
            .count()
            * (expansion_length - 1)
        + ymax
        - ymin
        + expansions
            .1
            .iter()
            .filter(|y| ymin < **y && **y < ymax)
            .count()
            * (expansion_length - 1)
}

fn parse(input: &str) -> Vec<Vec<char>> {
    input.lines().map(|x| x.chars().collect()).collect()
}

fn find_galaxies(map: &Vec<Vec<char>>) -> Vec<(usize, usize)> {
    map.iter()
        .enumerate()
        .flat_map(|(y, row)| {
            row.iter()
                .enumerate()
                .filter_map(move |(x, val)| (*val == '#').then_some((y, x)))
        })
        .collect()
}

fn find_empty_lines(map: &Vec<Vec<char>>) -> (Vec<usize>, Vec<usize>) {
    let horizontal_empty = map
        .iter()
        .enumerate()
        .filter_map(|(idx, row)| {
            (row.iter().filter(|x| **x == '.').count() == map[0].len()).then_some(idx)
        })
        .collect();
    let vertical_empty = (0..map[0].len())
        .into_iter()
        .enumerate()
        .filter_map(|(idx, col)| {
            ((0..map.len()).into_iter().all(|row| map[row][col] == '.')).then_some(idx)
        })
        .collect();

    (horizontal_empty, vertical_empty)
}
