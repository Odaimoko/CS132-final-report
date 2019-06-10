function press_(testCase, btn)
    p = btn.Position;
    btn.Position = [-30, 15, 64, 93];
    testCase.press(btn);
    btn.Position = p;
end
