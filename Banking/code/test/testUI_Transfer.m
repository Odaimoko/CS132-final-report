classdef  testUI_Transfer< matlab.uitest.TestCase
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
        function test_Transfer_normal(testCase)
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
            
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            to_id = card_id;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
        
            testCase.press(testCase.App.transfer);
            testCase.type(testCase.App.Account_Input, id);
            testCase.type(testCase.App.To_Account_Input, to_id);
            testCase.type(testCase.App.Amount_Input, 100);
            testCase.type(testCase.App.PW_Input, '123');
            testCase.press(testCase.App.Confirm_transfer);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Money transfered successfully']);
        end
        
        
        
    end
    
end