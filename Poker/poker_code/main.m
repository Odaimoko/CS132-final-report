% Note : all the comments of the code and the design details are in software specification
% document, you can read the document to find out the same variable and function declarations,

function main()
clc
close all
clear all

cManager = CardManager;
gManager = GameManager;
rManager = RuleManager;
pDB = PlayerDB;


gManager.CardManager = cManager;
gManager.RuleManager = rManager;
gManager.PlayerDB = pDB;

p1UI = PlayerUI(1);
p2UI = PlayerUI(2);
p3UI = PlayerUI(3);

p1UI.GameManager = gManager;
p2UI.GameManager = gManager;
p3UI.GameManager = gManager;

gManager.PlayerUI1 = p1UI;
gManager.PlayerUI2 = p2UI;
gManager.PlayerUI3 = p3UI;
end

