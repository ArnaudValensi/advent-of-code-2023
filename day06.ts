function winning_move(time, dist) {
  for (let i = 1; i < time; i++) {
    const velocity = i * (time - i);
    if (velocity > dist) {
      return time - (i * 2 - 1);
    }
  }

  return 0;
}

function part1() {
  const races = [
    [44, 208],
    [80, 1581],
    [65, 1050],
    [72, 1102],
  ];

  const result = races.reduce(
    (acc, [time, dist]) => acc * winning_move(time, dist),
    1
  );

  console.log(result);
}

function part2() {
  // const race = [7, 9]; // 0 6 10 12 12 10 6 0.
  // const race = [71530, 940200];
  const time = 44806572;
  const dist = 208158110501102;

  console.log(winning_move(time, dist));
}

part1();
part2();
