classdef tc2 < matlab.uitest.TestCase

    properties
        gManager;
    end

    methods (TestMethodSetup)

        function launchApp(testCase)
            clc
            close all
            addpath('..');
            testCase.gManager = GameManager;
            cManager = CardManager;
            rManager = RuleManager;
            pDB = PlayerDB;

            testCase.gManager.CardManager = cManager;
            testCase.gManager.RuleManager = rManager;
            testCase.gManager.PlayerDB = pDB;

            p1UI = PlayerUI(1);
            p2UI = PlayerUI(2);
            p3UI = PlayerUI(3);

            p1UI.GameManager = testCase.gManager;
            p2UI.GameManager = testCase.gManager;
            p3UI.GameManager = testCase.gManager;

            testCase.gManager.PlayerUI1 = p1UI;
            testCase.gManager.PlayerUI2 = p2UI;
            testCase.gManager.PlayerUI3 = p3UI;
            % testCase.addTeardown(@delete,testCase.App);

        end

    end

    methods (Test)

        function test(testCase)
            gm = testCase.gManager;
            p1 = gm.PlayerUI1;
            p2 = gm.PlayerUI2;
            p3 = gm.PlayerUI3;
            cm = gm.CardManager;
            testCase.enter_name_and_start();
            % Give cards
            testCase.distributeCards();
            % lord
            testCase.press(p1.GrabtheLandlordButton);
            testCase.press(p2.NotGrabButton);
            testCase.press(p3.NotGrabButton);

            % ---------------------1-------------------
            press_(testCase, p1.Button_1);
            press_(testCase, p1.Button_2);
            testCase.press(p1.PlayButton);

            testCase.press(p2.PassButton);

            press_(testCase, p3.Button_1);
            press_(testCase, p3.Button_2);
            testCase.press(p3.PlayButton);

            testCase.press(p1.PassButton);
            testCase.press(p2.PassButton);

            % ---------------------2-------------------
            press_(testCase, p3.Button_3);
            press_(testCase, p3.Button_4);
            press_(testCase, p3.Button_5);
            press_(testCase, p3.Button_6);
            press_(testCase, p3.Button_7);
            press_(testCase, p3.Button_9);
            press_(testCase, p3.Button_10);
            testCase.press(p3.PlayButton);
            press_(testCase, p3.Button_9);
            press_(testCase, p3.Button_10);
            press_(testCase, p3.Button_8);
            testCase.press(p3.PlayButton);

            testCase.press(p1.PassButton);

            press_(testCase, p2.Button_3);
            press_(testCase, p2.Button_4);
            press_(testCase, p2.Button_5);
            press_(testCase, p2.Button_6);
            testCase.press(p2.PlayButton);

            testCase.press(p3.PassButton);
            testCase.press(p1.PassButton);

            % ---------------------3-------------------

            press_(testCase, p2.Button_7);
            press_(testCase, p2.Button_8);
            press_(testCase, p2.Button_9);
            press_(testCase, p2.Button_10);
            press_(testCase, p2.Button_11);
            press_(testCase, p2.Button_12);
            testCase.press(p2.PlayButton);

            press_(testCase, p3.Button_9);
            press_(testCase, p3.Button_10);
            press_(testCase, p3.Button_11);
            press_(testCase, p3.Button_12);
            press_(testCase, p3.Button_13);
            press_(testCase, p3.Button_14);
            testCase.press(p3.PlayButton);

            press_(testCase, p1.Button_11);
            press_(testCase, p1.Button_12);
            press_(testCase, p1.Button_13);
            press_(testCase, p1.Button_14);
            testCase.press(p1.PlayButton);
            testCase.press(p2.PassButton);
            testCase.press(p3.PassButton);

            % ---------------------4-------------------

            press_(testCase, p1.Button_3);
            press_(testCase, p1.Button_4);
            testCase.press(p1.PlayButton);

            testCase.press(p2.PassButton);

            press_(testCase, p3.Button_16);
            press_(testCase, p3.Button_17);
            testCase.press(p3.PlayButton);

            press_(testCase, p1.Button_19);
            press_(testCase, p1.Button_20);
            testCase.press(p1.PlayButton);

            testCase.press(p2.PassButton);
            testCase.press(p3.PassButton);

            % ---------------------5-------------------

            press_(testCase, p1.Button_6);
            testCase.press(p1.PlayButton);
            testCase.press(p2.PassButton);

            press_(testCase, p3.Button_15);
            testCase.press(p3.PlayButton);
            % OVER

        end

        function enter_name_and_start(testCase)
            %  Enter Name
            gm = testCase.gManager;
            p1 = gm.PlayerUI1;
            p2 = gm.PlayerUI2;
            p3 = gm.PlayerUI3;
            testCase.type(p1.EnterNameEditField, 'Archer');
            testCase.type(p2.EnterNameEditField, 'Berserker');
            testCase.type(p3.EnterNameEditField, 'Caster');
            testCase.press(p1.ConfirmButton);
            testCase.press(p2.ConfirmButton);
            testCase.press(p3.ConfirmButton);
            testCase.press(p1.StartGameButton);
            testCase.press(p2.StartGameButton);
            testCase.press(p3.StartGameButton);

        end

        function distributeCards(testCase)
            gm = testCase.gManager;
            cm = gm.CardManager;
            cm.list_cards = [3, 3, 4, 4, 7, 8, 10, 11, 12, 12, 13, 13, 13, 14, 14, 14, 17, ...
                            3, 3, 5, 5, 5, 5, 7, 7, 8, 8, 9, 9, 10, 11, 12, 14, 15, ...
                            4, 4, 6, 6, 6, 6, 7, 8, 9, 9, 10, 10, 11, 11, 12, 15, 15, ...
                            13, 15, 16;
                        1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1, 2, 3, 1, 2, 3, 6, ...
                            3, 4, 1, 2, 3, 4, 2, 3, 2, 3, 1, 2, 2, 2, 3, 4, 1, ...
                            3, 4, 1, 2, 3, 4, 4, 4, 3, 4, 3, 4, 3, 4, 4, 2, 3, ...
                            4, 4, 5];
            cm.distribute();
            cm.lord_cards = cm.list_cards(:, 52:54);
            % gm.displayLordCard();
            gm.displayHandCard(1);
            gm.displayHandCard(2);
            gm.displayHandCard(3);
        end

    end

end
