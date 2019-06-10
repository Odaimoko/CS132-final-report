classdef  testUI_Deposit< matlab.uitest.TestCase
    properties
        App
        
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            addpath('..\src');
            addpath('..\src\datastructure');
            addpath('..\ui');
            testCase.App = UI_Clerk_exported;

            testCase.addTeardown(@delete,testCase.App);
            
        end
    end
    methods (Test)
        function test_Deposit_normal(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            id = card_id;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Account_Input, card_id);

            testCase.type(testCase.App.Amount_Input,100);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money added successfully']);
        end
        
        function test_Deposit_WAccount(testCase)
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Account_Input, 10000);
            testCase.type(testCase.App.Amount_Input,100);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money add failed']);
        end
        
        function test_Deposit_WAmount(testCase)
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Account_Input, 1);
            testCase.type(testCase.App.Amount_Input,-1);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Amount invalid']);
        end
        
        function test_Deposit_AbAmcount(testCase)
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Amount_Input,-1);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account cannot be emtpy']);
        end
        
        
    end
    
end