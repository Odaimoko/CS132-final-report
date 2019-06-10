classdef PlayerDB < handle    
    properties
        playerList
        PlayerManager
    end
    
    methods
        function obj= PlayerDB()
            if ~exist('data','dir')
                mkdir('data')
            end
            if exist('data/playerData.mat','file')
                load('data/playerData.mat','playerList');
                obj.playerList = playerList;
            end
        end
        
        function register(obj,playerName)
            newPlayer = Player;
            newPlayer.name = playerName;
            newPlayer.score = 0;
            obj.playerList=[obj.playerList;newPlayer];
        end
        
        % If not exist, register a new player with 'playerName'
        function score = retrieve(obj,playerName)
            score = 0;
            for i=1:length(obj.playerList)
                if strcmp(obj.playerList(i).name,playerName)
                    score = obj.playerList(i).score;
                    return
                end
            end
            obj.register(playerName);
        end
        
        function update(obj,playerName,score)
            for i=1:length(obj.playerList)
                if strcmp(obj.playerList(i).name,playerName)
                    obj.playerList(i).score = obj.playerList(i).score + score;
                    break;
                end
            end
        end
        
        function saveDB(obj)
            playerList = obj.playerList;
            save('data/playerData.mat','playerList');
        end 
    end
end