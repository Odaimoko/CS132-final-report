classdef testUI_CloseAccount < matlab.uitest.TestCase
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
        function test_CloseAccount_normal(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            % Close accout above
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.type(testCase.App.Account_Input,card_id);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account removed successfully.']);
            
        end
        function test_CloseAccount_WNum(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            % Close accout above
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.type(testCase.App.Account_Input,card_id+1);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account removed Failed']);
        end
        
        function test_CloseAccount_WAccount(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            % Close accout above
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.Identity_Input, 123+unidrnd(1000));
            testCase.type(testCase.App.PW_Input,'123');
            testCase.type(testCase.App.Account_Input,card_id);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Account removed Failed');
        end
        
        function test_CloseAccount_WPwd(testCase)
            testCase.press(testCase.App.open_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123');
            testCase.press(testCase.App.Confirm_open_account);
            db = Banking_system;
            card_id = db.db_account('nextCardID') - 1;
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, ['Account added successfully. ' newline 'Account No. ' num2str(card_id)]);
            % Close accout above
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.PW_Input,'123456');
            testCase.type(testCase.App.Account_Input,card_id);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Account removed Failed');
        end
        
        function test_CloseAccount_missAccount(testCase)
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.PW_Input, '123');
            testCase.type(testCase.App.Account_Input,1);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Id cannot be emtpy');
        end
        function test_CloseAccount_missPwd(testCase)
            testCase.press(testCase.App.close_account);
            testCase.type(testCase.App.Identity_Input, 123);
            testCase.type(testCase.App.Account_Input,1);
            testCase.press(testCase.App.Confirm_close_account);
            testCase.verifyEqual(testCase.App.Message_Feedback.Text, 'Password cannot be emtpy');
        end
        
        
        
        
        
    end
    
end