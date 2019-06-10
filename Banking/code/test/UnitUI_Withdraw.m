
classdef  testUI_Withdraw< matlab.uitest.TestCase
    properties
        App
        id = 1;
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
        function obj = test_Withdraw_normal(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            
            testCase.press(testCase.App.deposit);
            testCase.type(testCase.App.Account_Input, card_id);
            testCase.type(testCase.App.Amount_Input,100);
            testCase.press(testCase.App.Confirm_deposit_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money added successfully']);
            
            % withdraw
            testCase.press(testCase.App.withdraw);
            testCase.type(testCase.App.Account_Input,card_id);
            testCase.type(testCase.App.Amount_Input,100);
            testCase.press(testCase.App.Confirm_withdraw_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money withdrawn successfully']);
            
        end
        
        function test_Withdraw_Acced(testCase)
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            % withdraw
            testCase.press(testCase.App.withdraw);
            testCase.type(testCase.App.Account_Input, card_id);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.type(testCase.App.Amount_Input,1000);
            testCase.press(testCase.App.Confirm_withdraw_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money withdrawn failed']);
            
        end
        
        function test_Withdraw_Minus(testCase)
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            % withdraw
            testCase.press(testCase.App.withdraw);
            testCase.type(testCase.App.Account_Input, card_id);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.type(testCase.App.Amount_Input,-4);
            testCase.press(testCase.App.Confirm_withdraw_money);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Amount invalid']);
            
        end
        
    end
    
end