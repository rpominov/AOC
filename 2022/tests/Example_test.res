open Jest

test("example", () => {
  expect(Example.sum(1, 2))->toMatchSnapshot
})
