def print_answers(answer1: int, answer2: int) -> None:
    print("Answer 1:", answer1)
    if answer2 == -1:
        x = "Not finished yet"
    else
        x = answer2
    print("Answer 2:", x)

def get_data_and_parse(parser, day_number):
    with open('resources/adv' + day_number + '.txt') as f:
        return parser(f.read())
