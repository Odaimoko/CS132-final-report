classdef testIntegration < matlab.uitest.TestCase
    properties
        App
        App2
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            addpath('..');
            delete('data/cashier_db.mat');
            testCase.App2 = ManagerUI;
            testCase.App = CustomerUI;
            
            
            testCase.addTeardown(@delete,testCase.App);
            testCase.addTeardown(@delete,testCase.App2);
        end
    end
    methods (Test)
        function test_AddNewBrand(testCase)
            % State: Initially state.
            % Input: In ManagerUI, register a new brand with a existing type.
            %        In CashierUI, press the '同步商品信息’ button.
            % Expected Output: In CashierUI, the new brand displays correctly.
            testCase.press(testCase.App.Menu1_2);
            %pause(3);
            testCase.verifyEqual(testCase.App.item3.Visible,'off');
            
            testCase.type(testCase.App2.brand,'上好佳');
            
            %pause(1);
            testCase.type(testCase.App2.type,'薯片');
           % pause(1);
            testCase.choose(testCase.App2.DropDown,'食品');
            %pause(1);
            testCase.type(testCase.App2.price,3);
            %pause(1);
            testCase.type(testCase.App2.img,'img/shj.jpg');
            testCase.type(testCase.App2.num,10);
            %pause(1);
            testCase.press(testCase.App2.registerButton);
            %pause(2);
            
            testCase.press(testCase.App.Syn);
            %pause(2);
            testCase.press(testCase.App.Menu1_2);
            %pause(1);
            testCase.press(testCase.App.item3);
            
            testCase.verifyEqual(testCase.App.item3.Text, '上好佳');
            
            %pause(5);
            
            
        end
                
        function test_AddNewType(testCase)
            % State: Initially state.
            % Input: In ManagerUI, register a new brand with a new type.
            %        In CashierUI, press the '同步商品信息’ button.
            % Expected Output: In CashierUI, the new type displays
            % correctly.:

            
            %pause(3);
            testCase.verifyEqual(testCase.App.Menu3_2.Visible,'off');
            
            testCase.type(testCase.App2.brand,'可口可乐');
            
            %pause(1);
            testCase.type(testCase.App2.type,'汽水');
           % pause(1);
            testCase.choose(testCase.App2.DropDown,'饮料');
            %pause(1);
            testCase.type(testCase.App2.price,3);
            %pause(1);
            testCase.type(testCase.App2.img,'img/kkkl.jpg');
            testCase.type(testCase.App2.num,10);
            testCase.press(testCase.App2.registerButton);
            %pause(2);
            
            testCase.press(testCase.App.Syn);
            %pause(2);
            testCase.press(testCase.App.Menu1_3);
            %pause(2);
            testCase.press(testCase.App.item1);
            
            testCase.verifyEqual(testCase.App.item1.Text, '可口可乐');
            %pause(5);
                  
        end
        


        
        
    end
    
end