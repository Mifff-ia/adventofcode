use std::fmt::Display;

pub fn answer1(input: &str) -> i64 {
    let data = parse(input);
    let start = find_start(&data);
    let start_direction = start_direction(start, &data);
    // println!("{start:?}, {start_direction:?}");
    let mut loc = shift(start, &start_direction);
    let mut face = start_direction;

    let mut count = 0;
    while loc != start {
        let (x, y) = loc;
        count += 1;
        face = orientate(&data[x][y], &face);
        loc = shift(loc, &face);
    }
    count / 2 + count % 2
}

pub fn answer2(input: &str) -> i64 {
    let data = parse(input);
    let mut flood = FloodMap::new(&data);
    flood.flood_fill();
    flood.count_empty()
}

#[derive(Debug)]
struct FloodMap {
    map: Vec<Vec<FloodTile>>,
}

impl Display for FloodMap {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.map.iter().for_each(|x| {
            x.iter()
                .for_each(|ch| f.write_fmt(format_args!("{}", ch)).unwrap());
            f.write_str("\n").unwrap()
        });
        Ok(())
    }
}

impl FloodMap {
    fn new(map: &Vec<Vec<Tile>>) -> Self {
        let mut ans = Self {
            map: vec![vec![FloodTile::Empty; map[0].len() * 2 + 1]; map.len() * 2 + 1],
        };
        let start = find_start(&map);
        let start_direction = start_direction(start, &map);
        let mut loc = shift(start, &start_direction);
        let mut face = start_direction;
        ans.fill(start, &face);

        while loc != start {
            let (x, y) = loc;
            face = orientate(&map[x][y], &face);
            ans.fill(loc, &face);
            loc = shift(loc, &face);
        }
        ans
    }

    fn flood_fill(&mut self) {
        let mut frontier = vec![(0, 0)];
        while !frontier.is_empty() {
            let (x, y) = frontier.pop().unwrap();
            if x != self.map.len() - 1 && self.map[x + 1][y] == FloodTile::Empty {
                frontier.push((x + 1, y))
            }
            if x != 0 && self.map[x - 1][y] == FloodTile::Empty {
                frontier.push((x - 1, y))
            }
            if y != self.map[0].len() - 1 && self.map[x][y + 1] == FloodTile::Empty {
                frontier.push((x, y + 1))
            }
            if y != 0 && self.map[x][y - 1] == FloodTile::Empty {
                frontier.push((x, y - 1))
            }
            self.map[x][y] = FloodTile::Filled;
        }
    }

    fn count_empty(&self) -> i64 {
        self.map
            .iter()
            .skip(1)
            .step_by(2)
            .flat_map(|x| x.iter().skip(1).step_by(2))
            .filter(|x| **x == FloodTile::Empty)
            .count() as i64
    }

    fn pipe_to_flood_loc((x, y): (usize, usize)) -> (usize, usize) {
        (x * 2 + 1, y * 2 + 1)
    }

    fn fill(&mut self, (x, y): (usize, usize), face: &Direction) {
        let (x, y) = Self::pipe_to_flood_loc((x, y));
        self.map[x][y] = FloodTile::Wall;
        let (x, y) = shift((x, y), &face);
        self.map[x][y] = FloodTile::Wall;
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
enum FloodTile {
    Filled,
    Empty,
    Wall,
}

impl Display for FloodTile {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_fmt(format_args!(
            "{}",
            match self {
                Self::Filled => '~',
                Self::Wall => '#',
                Self::Empty => '.',
            }
        ))
    }
}

fn parse(input: &str) -> Vec<Vec<Tile>> {
    input
        .lines()
        .map(|x| x.chars().map(Tile::from).collect())
        .collect()
}

fn orientate(tile: &Tile, direction: &Direction) -> Direction {
    match direction {
        Direction::Up => match tile {
            Tile::Vertical => Direction::Up,
            Tile::SouthEast => Direction::Right,
            Tile::SouthWest => Direction::Left,
            _ => unreachable!(),
        },
        Direction::Down => match tile {
            Tile::Vertical => Direction::Down,
            Tile::NorthEast => Direction::Right,
            Tile::NorthWest => Direction::Left,
            _ => unreachable!(),
        },
        Direction::Left => match tile {
            Tile::Horizontal => Direction::Left,
            Tile::NorthEast => Direction::Up,
            Tile::SouthEast => Direction::Down,
            _ => unreachable!(),
        },
        Direction::Right => match tile {
            Tile::Horizontal => Direction::Right,
            Tile::NorthWest => Direction::Up,
            Tile::SouthWest => Direction::Down,
            _ => unreachable!(),
        },
    }
}

fn shift((x, y): (usize, usize), direction: &Direction) -> (usize, usize) {
    match direction {
        Direction::Up => (x - 1, y),
        Direction::Down => (x + 1, y),
        Direction::Right => (x, y + 1),
        Direction::Left => (x, y - 1),
    }
}

#[derive(Debug)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

impl From<char> for Tile {
    fn from(value: char) -> Self {
        match value {
            '|' => Tile::Vertical,
            '-' => Tile::Horizontal,
            'L' => Tile::NorthEast,
            'J' => Tile::NorthWest,
            '7' => Tile::SouthWest,
            'F' => Tile::SouthEast,
            '.' => Tile::Ground,
            'S' => Tile::Start,
            _ => unreachable!(),
        }
    }
}

fn start_direction((x, y): (usize, usize), map: &Vec<Vec<Tile>>) -> Direction {
    if x != map[0].len() - 1
        && [Tile::NorthWest, Tile::SouthWest, Tile::Horizontal].contains(&map[x][y + 1])
    {
        Direction::Right
    } else if x != 0
        && [Tile::NorthEast, Tile::SouthEast, Tile::Horizontal].contains(&map[x][y - 1])
    {
        Direction::Left
    } else if y != map.len() - 1
        && [Tile::NorthEast, Tile::NorthWest, Tile::Vertical].contains(&map[x + 1][y])
    {
        Direction::Down
    } else if y != 0 && [Tile::SouthEast, Tile::SouthWest, Tile::Vertical].contains(&map[x - 1][y])
    {
        Direction::Up
    } else {
        unreachable!()
    }
}

fn find_start(map: &Vec<Vec<Tile>>) -> (usize, usize) {
    for (i, lane) in map.iter().enumerate() {
        for (j, tile) in lane.iter().enumerate() {
            if *tile == Tile::Start {
                return (i, j);
            }
        }
    }
    unreachable!()
}

#[derive(PartialEq, Eq, Debug)]
enum Tile {
    Vertical,
    Horizontal,
    NorthEast,
    NorthWest,
    SouthWest,
    SouthEast,
    Start,
    Ground,
}
