% Note : all the comments of the code and the design details are in software specification
% document, you can read the document to find out the same variable and function declarations,
classdef GameManager < handle
    properties
        PlayerUI1     % the UI of the players
        PlayerUI2
        PlayerUI3
        CardManager
        RuleManager
        PlayerDB
        
        nameList = {'','',''};
        scoreList = [0,0,0];
        
        
        landlord    %the landlord of this round of game 
       
        lastWinnnerNum = 1    %the winner of last round of game, default player 1, 
                        %Use for determining who will start the next round of landlord grab
        
        player_states = [0,0,0];  %init [0,0,0], when the ith player click the ¡®Start Game¡¯ button, 
                                %his states player_states(i) changes to 1
                                                                
        grabRound = 1;
        grabSequence = [];

    end
    methods
        function score = retrieveScore(obj,playerNum,playerName)
            score = obj.PlayerDB.retrieve(playerName);
            obj.nameList(playerNum) = cellstr(playerName);
            obj.scoreList(playerNum) = score;
        end
        
        function logged = isNameLogged(obj,playerName)
            logged = 0;
            for i = 1:length(obj.nameList)
                if strcmp(obj.nameList(i),playerName)
                    logged = 1;
                end
            end
        end
        function waitAllPlayerReady(obj,playerNum)
            obj.player_states(playerNum) = 1;            
            if obj.player_states == [1,1,1]
                obj.CardManager.shuffle();
                obj.CardManager.distribute();
                obj.displayPlayerName();
                obj.displayPlayerScore();
                obj.displayMessage(1,'Game Start');
                obj.displayHandCard(1);
                obj.displayMessage(2,'Game Start');
                obj.displayHandCard(2);
                obj.displayMessage(3,'Game Start');
                obj.displayHandCard(3);
                obj.startLordGrab();

            else
                obj.displayMessage(playerNum,'Please wait for other players.');
            end   
        end
        
        function reshuffleCard(obj)
            obj.CardManager.shuffle();
            obj.CardManager.distribute();
            obj.displayMessage(1,'The cards reshuffled');
            obj.displayHandCard(1);
            obj.displayMessage(2,'The cards reshuffled');
            obj.displayHandCard(2);
            obj.displayMessage(3,'The cards reshuffled');
            obj.displayHandCard(3);
            obj.startLordGrab();
        end
        
        
        function startLordGrab(obj)
            obj.grabRound = 1;
            switch obj.lastWinnnerNum
                case 1
                    obj.grabSequence = [1,2,3];
                case 2
                    obj.grabSequence = [2,3,1];
                case 3
                    obj.grabSequence = [3,1,2];
            end
            
            obj.TurnLampOn(obj.lastWinnnerNum);
            PlayerUI = eval(strcat('obj.PlayerUI',num2str(obj.lastWinnnerNum)));
            PlayerUI.GrabLandLordPanel.Visible = 'on';
        end
        
        function processGrabLordInput(obj,playerNum,grabFlag)  
            curIndex = find(obj.grabSequence == playerNum);
            nextIndex = 0;
            addRoundFlag = 0;
            PlayerUI = eval(strcat('obj.PlayerUI',num2str(playerNum)));
            PlayerUI.GrabLandLordPanel.Visible = 'off';
            obj.TurnLampOff(playerNum);
            if grabFlag == -1
                obj.grabSequence(curIndex) = 0;
                obj.displayMessageToAll(playerNum,"I don't grab");
            else
                obj.displayMessageToAll(playerNum,'I grab the landlord');
            end

            
            if curIndex == length(obj.grabSequence)
                addRoundFlag = 1;
                nextIndex = 1;
                obj.grabSequence = obj.grabSequence(obj.grabSequence ~= 0);
            else
                nextIndex = curIndex + 1;
            end
            
            % if nobody grab the landlord, reshuffle the cards
            if isempty(obj.grabSequence)
                obj.reshuffleCard();
                return 
            end
            
            %In the second round of the grabbing, the first one chooses to
            %grab the landlord again becomes the landlord.
            if obj.grabRound == 2 && grabFlag == 1
                obj.landlord = playerNum;
                obj.determineLandlord();
                return
            end
                                   
            %adjust grab round
            if addRoundFlag
                obj.grabRound = obj.grabRound + 1;
            end
            
            %In the second round of the grabbing, no one chooses to
            %grab the landlord again, so the last player grab the lord
            %in the first round becomes the landlord
            grabberRemain = length(obj.grabSequence(obj.grabSequence ~= 0));
            if obj.grabRound == 2 && grabberRemain == 1
                obj.landlord = obj.grabSequence(1);
                obj.determineLandlord();
                return
            end
            
            %The grabbing not finish, continue to next player
            obj.TurnLampOn(obj.grabSequence(nextIndex));
            PlayerUI = eval(strcat('obj.PlayerUI',num2str(obj.grabSequence(nextIndex))));
            PlayerUI.GrabLandLordPanel.Visible = 'on';
            
        end
            
        function determineLandlord(obj)
            obj.cleanAllMessage();
            obj.displayMessage(obj.landlord,"You are the Landlord");
            obj.LandLordLampOn(obj.landlord);
            tmp = [1,2,3]; farmer = tmp(tmp ~= obj.landlord); 
            for i = 1:length(farmer)
                obj.displayMessage(farmer(i),"You are a farmer");
            end
            
            obj.CardManager.distributeLordCard(obj.landlord);
            obj.displayLordCard();  
            obj.displayHandCard(obj.landlord);
            obj.startPlayCard();
        end
        
        function startPlayCard(obj)
            player_num = obj.landlord;
            obj.displayLeftCard();
            PlayerUI = eval(strcat('obj.PlayerUI',num2str(player_num)));
            obj.TurnLampOn(player_num);
            obj.displayMessage(player_num,'Please play cards');
            PlayerUI.playCardFlag = 0;
            PlayerUI.PlayCardPanel.Visible = 'on';
        end
        
        function processPlayCard(obj,player_num,playFlag,cardsIndex)
            PlayerUI = eval(strcat('obj.PlayerUI',num2str(player_num)));
            finishFlag = 0;
            %player click the pass button
            if playFlag == 0
                if obj.RuleManager.lastPlayCardPlayer == 0 || obj.RuleManager.lastPlayCardPlayer == player_num
                    PlayerUI.displayMessage('Please play cards');
                    return;
                else
                    obj.displayMessageToAll(player_num,'Pass');
                end
            else   %player click the play button
                cards = obj.CardManager.retrieveCard(player_num,cardsIndex);
                if  ~obj.RuleManager.isValid(cards,player_num)
                    PlayerUI.displayMessage('Invalid , please re-select');
                    return;
                end
                obj.displayOutCard(cards); 
                numCardsLeft = obj.CardManager.updateLeftCard(player_num,length(cards(1,:)));
                obj.displayLeftCard();
                if numCardsLeft == 0
                    finishFlag = 1;
                end
                obj.hideHandCard(player_num,cardsIndex);
                obj.displayMessageToAll(player_num,'');
            end
            PlayerUI.PlayCardPanel.Visible = 'off';
            
            if finishFlag
                obj.determineWinner(player_num);
                return;
            end
            
            obj.TurnLampOff(player_num);
            player_num = player_num +1;
            if player_num > 3
                player_num = 1;
            end
            PlayerUI = eval(strcat('obj.PlayerUI',num2str(player_num)));
            obj.TurnLampOn(player_num);
            obj.displayMessage(player_num,'Please play cards');
            PlayerUI.playCardFlag = 0;
            PlayerUI.PlayCardPanel.Visible = 'on';
        end
        
        function determineWinner(obj,winnerNum)
            adjustment = obj.adjustScore(winnerNum);
            obj.displayResult(adjustment);
            obj.player_states = [0,0,0];
            obj.lastWinnnerNum = winnerNum;
        end
        
        function TurnLampOn(obj,playerNum)
            switch playerNum
                case 1
                    obj.PlayerUI1.LampOn(obj.PlayerUI1.TurnLamp);
                    
                    obj.PlayerUI2.LampOn(obj.PlayerUI2.TurnLamp_3);
                    obj.PlayerUI3.LampOn(obj.PlayerUI3.TurnLamp_2);
                case 2
                    obj.PlayerUI2.LampOn(obj.PlayerUI2.TurnLamp);
                    
                    obj.PlayerUI1.LampOn(obj.PlayerUI1.TurnLamp_2);
                    obj.PlayerUI3.LampOn(obj.PlayerUI3.TurnLamp_3);
                case 3
                    obj.PlayerUI3.LampOn(obj.PlayerUI3.TurnLamp);
                    
                    obj.PlayerUI2.LampOn(obj.PlayerUI2.TurnLamp_2);
                    obj.PlayerUI1.LampOn(obj.PlayerUI1.TurnLamp_3);
            end
        end
        
        function TurnLampOff(obj,playerNum)
            switch playerNum
                case 1
                    obj.PlayerUI1.LampOff(obj.PlayerUI1.TurnLamp);
                    obj.PlayerUI2.LampOff(obj.PlayerUI2.TurnLamp_3);
                    obj.PlayerUI3.LampOff(obj.PlayerUI3.TurnLamp_2);
                case 2
                    obj.PlayerUI2.LampOff(obj.PlayerUI2.TurnLamp);
                    obj.PlayerUI1.LampOff(obj.PlayerUI1.TurnLamp_2);
                    obj.PlayerUI3.LampOff(obj.PlayerUI3.TurnLamp_3);
                case 3
                    obj.PlayerUI3.LampOff(obj.PlayerUI3.TurnLamp);
                    obj.PlayerUI2.LampOff(obj.PlayerUI2.TurnLamp_2);
                    obj.PlayerUI1.LampOff(obj.PlayerUI1.TurnLamp_3);
            end
        end
        
        function LandLordLampOn(obj,playerNum)
            switch playerNum
                case 1
                    obj.PlayerUI1.LampOn(obj.PlayerUI1.LandLordLamp);
                    
                    obj.PlayerUI2.LampOn(obj.PlayerUI2.LandLordLamp_3);
                    obj.PlayerUI3.LampOn(obj.PlayerUI3.LandLordLamp_2);
                case 2
                    obj.PlayerUI2.LampOn(obj.PlayerUI2.LandLordLamp);
                    
                    obj.PlayerUI1.LampOn(obj.PlayerUI1.LandLordLamp_2);
                    obj.PlayerUI3.LampOn(obj.PlayerUI3.LandLordLamp_3);
                case 3
                    obj.PlayerUI3.LampOn(obj.PlayerUI3.LandLordLamp);
                    
                    obj.PlayerUI2.LampOn(obj.PlayerUI2.LandLordLamp_2);
                    obj.PlayerUI1.LampOn(obj.PlayerUI1.LandLordLamp_3);
            end
        end
        
        function LandLordLampOff(obj,playerNum)
            switch playerNum
                case 1
                    obj.PlayerUI1.LampOff(obj.PlayerUI1.LandLordLamp);
                    obj.PlayerUI2.LampOff(obj.PlayerUI2.LandLordLamp_3);
                    obj.PlayerUI3.LampOff(obj.PlayerUI3.LandLordLamp_2);
                case 2
                    obj.PlayerUI2.LampOff(obj.PlayerUI2.LandLordLamp);
                    obj.PlayerUI1.LampOff(obj.PlayerUI1.LandLordLamp_2);
                    obj.PlayerUI3.LampOff(obj.PlayerUI3.LandLordLamp_3);
                case 3
                    obj.PlayerUI3.LampOff(obj.PlayerUI3.LandLordLamp);
                    obj.PlayerUI2.LampOff(obj.PlayerUI2.LandLordLamp_2);
                    obj.PlayerUI1.LampOff(obj.PlayerUI1.LandLordLamp_3);
            end
        end
        
        
        
        function displayMessage(obj,playerNum,Message)
            switch playerNum
                case 1
                    obj.PlayerUI1.Message.Text=Message;
                case 2
                    obj.PlayerUI2.Message.Text=Message;
                case 3
                    obj.PlayerUI3.Message.Text=Message;
            end
        end
        
        function displayMessageToAll(obj,playerNum,Message)
            switch playerNum
                case 1
                    obj.PlayerUI1.Message.Text=Message;
                    obj.PlayerUI2.Message_3.Text=Message;
                    obj.PlayerUI3.Message_2.Text=Message;
                case 2
                    obj.PlayerUI2.Message.Text=Message;
                    obj.PlayerUI1.Message_2.Text=Message;
                    obj.PlayerUI3.Message_3.Text=Message;
                case 3
                    obj.PlayerUI3.Message.Text=Message;
                    obj.PlayerUI2.Message_2.Text=Message;
                    obj.PlayerUI1.Message_3.Text=Message;
            end
        end
        
        function cleanAllMessage(obj)
            obj.PlayerUI1.cleanAllMessage();
            obj.PlayerUI2.cleanAllMessage();
            obj.PlayerUI3.cleanAllMessage();
        end
        
        function  displayHandCard(obj,playerNum)
            switch playerNum
                case 1
                    obj.PlayerUI1.displayHandCard(obj.CardManager.player_cards1);
                case 2
                    obj.PlayerUI2.displayHandCard(obj.CardManager.player_cards2);
                case 3 
                    obj.PlayerUI3.displayHandCard(obj.CardManager.player_cards3);
            end
        end
        
        function displayLordCard(obj)
            obj.PlayerUI1.displayLordCard(obj.CardManager.lord_cards);
            obj.PlayerUI2.displayLordCard(obj.CardManager.lord_cards);
            obj.PlayerUI3.displayLordCard(obj.CardManager.lord_cards);
        end
        
        function displayOutCard(obj,cards)
            obj.PlayerUI1.displayOutCard(cards);
            obj.PlayerUI2.displayOutCard(cards);
            obj.PlayerUI3.displayOutCard(cards);
        end
        
        function hideHandCard(obj,playerNum,cardsIndex)
            PlayerUI = eval(strcat('obj.PlayerUI',num2str(playerNum)));
            PlayerUI.hideHandCard(cardsIndex);
        end
        
        function displayLeftCard(obj)
            obj.PlayerUI1.displayLeftCard(obj.CardManager.cards_left2,obj.CardManager.cards_left3);
            obj.PlayerUI2.displayLeftCard(obj.CardManager.cards_left3,obj.CardManager.cards_left1);
            obj.PlayerUI3.displayLeftCard(obj.CardManager.cards_left1,obj.CardManager.cards_left2);
        end
                
        function displayPlayerName(obj)            
            obj.PlayerUI1.displayPlayerName(obj.nameList(2),obj.nameList(3));
            obj.PlayerUI2.displayPlayerName(obj.nameList(3),obj.nameList(1));
            obj.PlayerUI3.displayPlayerName(obj.nameList(1),obj.nameList(2));
        end
        
        function displayPlayerScore(obj)
            obj.PlayerUI1.displayPlayerScore(obj.scoreList(1),obj.scoreList(2),obj.scoreList(3));
            obj.PlayerUI2.displayPlayerScore(obj.scoreList(2),obj.scoreList(3),obj.scoreList(1));
            obj.PlayerUI3.displayPlayerScore(obj.scoreList(3),obj.scoreList(1),obj.scoreList(2));
        end
        
        function adjustment = adjustScore(obj, winnerNum)
            winPlayers = [];
            losePlayers = [];
            adjustment = [0,0,0];
            tmp = [1,2,3];
            if winnerNum == obj.landlord
                winPlayers = [obj.landlord];
                losePlayers = tmp(tmp ~= obj.landlord);
            else
                winPlayers = tmp(tmp ~= obj.landlord);
                losePlayers = [obj.landlord];
            end
            for i = 1:length(winPlayers)
                if length(winPlayers) == 1
                    adjustment(winPlayers(i)) = +6;
                else
                adjustment(winPlayers(i)) = +3;
                end
            end
            for i = 1:length(losePlayers)
                adjustment(losePlayers(i)) = -3;
            end
            if length(losePlayers) == 1
                adjustment(losePlayers(1)) = adjustment(losePlayers(1)) -3;
            end
            for i = 1:3
                obj.scoreList(i) = obj.scoreList(i) + adjustment(i);
            end
        end

 
        function displayResult(obj,adjustment)
            obj.PlayerUI1.displayResult(obj.scoreList,adjustment);
            obj.PlayerUI2.displayResult(obj.scoreList,adjustment);
            obj.PlayerUI3.displayResult(obj.scoreList,adjustment);
        end
        
    end
end