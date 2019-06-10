% Note : all the comments of the code and the design details are in software specification
% document, you can read the document to find out the same variable and function declarations,
classdef RuleManager < handle
    properties
        error = 0; %Error type
        single = 1; %单张
        double = 2; %对子
        triple = 3; %三张
        threeAndOne = 4; %三带一
        sequence = 5; %五连顺子 (2不作为顺子）
        threeDouble = 6; %三连对
        airplane = 7; %飞机：两个连续三张加两个任意单张
        boom = 8; %四连炸弹或者王炸     
        fourAndTwo = 9; %四带二
        
        lastTypeValue = [-1,-1];  %default
        lastPlayCardPlayer = 0;
    end
    
    methods
         
        function valid = isValid(obj,cards,playerNum)
            if isempty(cards)
                valid = 0;
                return
            end
            cards = cards(1,:);
            typeValue = obj.getTypeValue(cards);
            valid = obj.isGreater(typeValue,playerNum);
            if valid              %set the lastTypeValue here
                obj.lastTypeValue = typeValue;
            end
        end
        
        
        
                                                    % cards is 1*n array
        function typeValue = getTypeValue(obj,cards)  % typeValue = [typeNum,value] 
            typeValue =[];
            switch length(cards)
                case 1
                    typeValue = [obj.single,cards];
                case 2
                    if cards(1) ~= cards(2)
                        if cards(1) == 16 && cards(2) == 17
                            typeValue = [obj.boom, 9999];
                        else
                            typeValue = [obj.error, 0];
                        end
                    else
                        typeValue = [obj.double,cards(1)];
                    end
                case 3
                    if cards(1) ~= cards(2) || cards(1) ~= cards(3)
                        typeValue = [obj.error, 0];
                    else
                        typeValue = [obj.triple,cards(1)];
                    end
                case 4
                    if cards(1) == cards(2) && cards(1) == cards(3) && cards(1) == cards(4)
                        typeValue = [obj.boom, cards(1)];
                    else
                        if cards(1) == cards(2) && cards(1) == cards(3)  %三带一，记录三张牌的大小
                            typeValue = [obj.threeAndOne,cards(1)];
                        elseif cards(2) == cards(3) && cards(2) == cards(4)
                            typeValue = [obj.threeAndOne,cards(2)];
                        else
                            typeValue = [obj.error, 0];
                        end
                    end
                case 5
                    if cards(5) == 15 || cards(5) == 16 || cards(5) == 17
                        typeValue = [obj.error, 0];
                    elseif obj.isSequence(cards)     %顺子，记录最大一张牌的大小
                        typeValue = [obj.sequence,cards(5)];
                    else
                        typeValue = [obj.error, 0];
                    end
                case 6      %三连对，记录最大一张牌的大小
                    if obj.isThreeDouble(cards)
                        typeValue = [obj.threeDouble,cards(6)];
                    elseif obj.isFourAndTwo(cards)   %四代二，记录第三张牌的大小
                        typeValue = [obj.fourAndTwo,cards(3)];
                    else
                        typeValue = [obj.error, 0];
                    end
                case 8    %飞机， 记录二连三张中较大的一张
                    value = obj.checkAirplane(cards);
                    if value 
                        typeValue = [obj.airplane,value];
                    else
                        typeValue = [obj.error, 0];
                    end
                otherwise
                    typeValue = [obj.error, 0];
            end
        end
     
        function result = isGreater(obj,typeValue,playerNum)   
            result = 0;
            if obj.lastTypeValue(1) == -1 || obj.lastPlayCardPlayer == playerNum
                if typeValue(1) ~= obj.error
                    obj.lastPlayCardPlayer = playerNum;
                    result = 1;
                end
                return
            end
      
            switch typeValue(1)
                case obj.boom
                    if obj.lastTypeValue(1) == obj.boom && obj.lastTypeValue(2) > typeValue(2)
                        return
                    else 
                        result = 1;
                        obj.lastPlayCardPlayer = playerNum;
                    end
                otherwise
                    if obj.lastTypeValue(1) == typeValue(1) && typeValue(2) > obj.lastTypeValue(2)
                        result = 1;
                        obj.lastPlayCardPlayer = playerNum;
                    end
            end
        end
        
        function result = isSequence(obj,cards)  
            result = 0;
            for i = 2:length(cards)
               if cards(i) ~= cards(i-1)+1
                   return;
               end
            end
            result = 1;
        end
        
        function result = isThreeDouble(obj,cards)  
            result = 0;
            if cards(1)~=cards(2) || cards(3)~=cards(4) || cards(5) ~= cards(6)
                return
            end
            if cards(1)+1~=cards(3) || cards(3)+1~=cards(5)
                return
            end
            result = 1;
        end
        
        function value = checkAirplane(obj,cards)
            value = 0;
            for i=8:-1:6
                if cards(i) == cards(i-1) && cards(i) == cards(i-2) && cards(i-3) == cards(i-4) && cards(i-3) == cards(i-5) && cards(i) == cards(i-3)+1
                    value = cards(i);
                    return
                end
            end
        end
        
        function value = isFourAndTwo(obj,cards)
            value = 0;
            for i=1:3
                if cards(i) == cards(i+1) && cards(i) == cards(i+2) && cards(i) == cards(i+3)
                    value = cards(i);
                    return
                end
            end
        end
    end
















end