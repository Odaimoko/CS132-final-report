% Note : all the comments of the code and the design details are in software specification
% document, you can read the document to find out the same variable and function declarations,
classdef CardManager < handle
    properties       % 'A' = 14  ,  '2' = 15 , 'Joker(small) = 16' , 'Joker(big) = 17'
        list_cards = [3 4 5 6 7 8 9 10 11 12 13 14 15 3 4 5 6 7 8 9 10 11 12 13 14 15 3 4 5 6 7 8 9 10 11 12 13 14 15 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17
                      1 1 1 1 1 1 1 1  1   1  1  1  1 2 2 2 2 2 2 2  2  2  2  2  2  2 3 3 3 3 3 3 3 3  3  3  3  3  3  4 4 4 4 4 4 4 4  4  4  4  4  4 5 6 ];
        player_cards1 
        cards_left1
        
        player_cards2
        cards_left2
        
        player_cards3
        cards_left3
        
        lord_cards
    end
    methods
        function obj = shuffle(obj)
           obj.list_cards = obj.list_cards(:,randperm(size(obj.list_cards,2)));
           obj.lord_cards = obj.list_cards(:,52:54);
        end
 
        function obj = distribute(obj)
            for i = 1:3
                index_num = (i-1)*17+1;  
                switch i  
                    case 1
                        obj.player_cards1=sortrows((obj.list_cards(:,index_num:index_num+16))',1)';
                        obj.cards_left1 = 17;
                    case 2
                        obj.player_cards2=sortrows((obj.list_cards(:,index_num:index_num+16))',1)';
                        obj.cards_left2 = 17;
                    case 3
                        obj.player_cards3=sortrows((obj.list_cards(:,index_num:index_num+16))',1)';
                        obj.cards_left3 = 17;
                end
            end
        end
        
        function obj = distributeLordCard(obj,player_num)
            switch player_num
                case 1
                    obj.player_cards1=sortrows([obj.player_cards1,obj.lord_cards]',1)';
                    obj.cards_left1 = 20;
                case 2
                    obj.player_cards2=sortrows([obj.player_cards2,obj.lord_cards]',1)';
                    obj.cards_left2 = 20;
                case 3
                    obj.player_cards3=sortrows([obj.player_cards3,obj.lord_cards]',1)';
                    obj.cards_left3 = 20;
            end
        end
        
        function cards = retrieveCard(obj,playerNum,cardsIndex)
           playerCards = eval(strcat('obj.player_cards',num2str(playerNum)));
           cards =[];
           for i = 1:length(cardsIndex)
               cards = [cards,playerCards(:,cardsIndex(i))];
           end
        end
        
        function cardsLeft = updateLeftCard(obj,playerNum,cardsNum)
            switch playerNum
                case 1
                    obj.cards_left1 = obj.cards_left1 - cardsNum;
                    cardsLeft = obj.cards_left1;
                case 2
                    obj.cards_left2 = obj.cards_left2 - cardsNum;
                    cardsLeft = obj.cards_left2;
                case 3
                    obj.cards_left3 = obj.cards_left3 - cardsNum;
                    cardsLeft = obj.cards_left3;
            end
        end
    end
end

