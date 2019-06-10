classdef testManagerUI < matlab.uitest.TestCase
    properties
        App
    end
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            addpath('..');
            testCase.App = ManagerUI;
            testCase.addTeardown(@delete,testCase.App);
        end
    end
    methods (Test)
        function test_inputBrand(testCase)
            value = '�ɿڿ���';
            testCase.type(testCase.App.brand, value);
            testCase.verifyEqual(testCase.App.brand.Value, value);
        end
        function test_inputType(testCase)
            value = '��ˮ';
            testCase.type(testCase.App.type, value);
            testCase.verifyEqual(testCase.App.type.Value, value);
        end
        
        function test_chooseDropDown(testCase)
            value = '����';
            testCase.choose(testCase.App.DropDown, value);
            testCase.verifyEqual(testCase.App.DropDown.Value, value);
        end
        
        function test_inputPrice(testCase)
            value = 123;
            testCase.type(testCase.App.price, value);
            testCase.verifyEqual(testCase.App.price.Value, value);
        end
        
        function test_inputImg(testCase)
            value = 'img/kkkl.jpg';
            testCase.type(testCase.App.img, value);
            testCase.verifyEqual(testCase.App.img.Value, value);
        end
               
        function test_inputNum(testCase)
            value = 10;
            testCase.type(testCase.App.num, value);
            testCase.verifyEqual(testCase.App.num.Value, value);
        end
        
        function test_InvalidPrice_negativeNum(testCase)
            % State: The price is not been entered, the other four inputs are valid.
            % Input: input a negative price, press the registerButton.
            % Expected Output: The errorInfo displays "��ȷ����������ȷ����Ʒ��Ϣ����".
            testCase.App.brand.Value = '�ɿڿ���';
            testCase.App.type.Value = '��ˮ';
            testCase.App.DropDown.Value =  '����';
            testCase.App.img.Value = 'img/kkkl.jpg';
            testCase.App.num.Value = 10;
            
            value = -123;
            testCase.type(testCase.App.price, value);
            testCase.press(testCase.App.registerButton);
            testCase.verifyEqual(testCase.App.errorInfo.Text,'��ȷ����������ȷ����Ʒ��Ϣ����' ); 
            pause(3);
        end
        
        function test_InvalidPrice_notNum(testCase)
            % State: The price is not been entered, the other four inputs are valid.
            % Input: input a price but not a number, press the registerButton.
            % Expected Output: The errorInfo displays "��ȷ����������ȷ����Ʒ��Ϣ����".
            testCase.App.brand.Value = '�ɿڿ���';
            testCase.App.type.Value = '��ˮ';
            testCase.App.DropDown.Value =  '����';
            testCase.App.img.Value = 'img/kkkl.jpg';
            testCase.App.num.Value = 10;
            
            value = 'ʮԪ';
            testCase.type(testCase.App.price, value);
            testCase.press(testCase.App.registerButton);
            testCase.verifyEqual(testCase.App.errorInfo.Text,'��ȷ����������ȷ����Ʒ��Ϣ����' ); 
            pause(3);
        end
        
        function test_InvalidNum_negativeNum(testCase)
            % State: The price is not been entered, the other four inputs are valid.
            % Input: input a negative price, press the registerButton.
            % Expected Output: The errorInfo displays "��ȷ����������ȷ����Ʒ��Ϣ����".
            testCase.App.brand.Value = '�ɿڿ���';
            testCase.App.type.Value = '��ˮ';
            testCase.App.DropDown.Value =  '����';
            testCase.App.img.Value = 'img/kkkl.jpg';
            testCase.App.price.Value = 3;
            
            value = -123;
            testCase.type(testCase.App.num, value);
            pause(1);
            testCase.press(testCase.App.registerButton);
            testCase.verifyEqual(testCase.App.errorInfo.Text,'��ȷ����������ȷ����Ʒ��Ϣ����' ); 
            pause(3);
        end
        
        function test_InvalidNUm_notNum(testCase)
            % State: The price is not been entered, the other four inputs are valid.
            % Input: input a price but not a number, press the registerButton.
            % Expected Output: The errorInfo displays "��ȷ����������ȷ����Ʒ��Ϣ����".
            testCase.App.brand.Value = '�ɿڿ���';
            testCase.App.type.Value = '��ˮ';
            testCase.App.DropDown.Value =  '����';
            testCase.App.img.Value = 'img/kkkl.jpg';
            testCase.App.price.Value = 3;
            
            value = 'ʮ��';
            testCase.type(testCase.App.num, value);
            pause(1);
            testCase.press(testCase.App.registerButton);
            testCase.verifyEqual(testCase.App.errorInfo.Text,'��ȷ����������ȷ����Ʒ��Ϣ����' ); 
            pause(3);
        end
        
        
        
        function test_InvalidImg_notPath(testCase)
            % State: The img is not been entered, the other four inputs are valid.
            % Input: Fill the img with a non-path, press the registerButton.
            % Expected Output: The errorInfo displays "��ȷ����������ȷ����Ʒ��Ϣ����".
            testCase.App.brand.Value = '�ɿڿ���';
            testCase.App.type.Value = '��ˮ';
            testCase.App.DropDown.Value =  '����';
            testCase.App.price.Value = 100;
            testCase.App.num.Value = 10;
            
            value = 'adadwdaw@ascac';
            testCase.type(testCase.App.img, value);
            testCase.press(testCase.App.registerButton);
            testCase.verifyEqual(testCase.App.errorInfo.Text,'��ȷ����������ȷ����Ʒ��Ϣ����' ); 
            pause(3);
            
        end
        
        
        
        function test_InvalidImg_wrongPath(testCase)
            % State: The img is not been entered, the other four inputs are valid.
            % Input: Fill the img with a wrong path, press the registerButton.
            % Expected Output: The errorInfo displays "��ȷ����������ȷ����Ʒ��Ϣ����".
            testCase.App.brand.Value = '�ɿڿ���';
            testCase.App.type.Value = '��ˮ';
            testCase.App.DropDown.Value =  '����';
            testCase.App.price.Value = 100;
            testCase.App.num.Value = 10;
            
            value = 'src/kkkl.jpg';
            testCase.type(testCase.App.img, value);
            testCase.press(testCase.App.registerButton);
            testCase.verifyEqual(testCase.App.errorInfo.Text,'��ȷ����������ȷ����Ʒ��Ϣ����' );       
            pause(3);
        end
        
        function test_registerButtonPushed(testCase)
            % State: The brand, type, dropDown, price and img are entered correctly.
            % Input: Press the registerButton.
            % Expected Output: The errorInfo displays "�Ǽǳɹ���".
            testCase.App.brand.Value = '�ɿڿ���';
            testCase.App.type.Value = '��ˮ';
            testCase.App.DropDown.Value =  '����';
            testCase.App.price.Value = 100;
            testCase.App.img.Value = 'img/kkkl.jpg';
            testCase.App.num.Value = 10;
            testCase.verifyEqual(testCase.App.errorInfo.Text,'�Ǽǳɹ���' );
            pause(3);
        end
        
        
        
        
        
    end
    
end