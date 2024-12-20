function [FNZw, FNMo, FNGl] = LoudRefSig
% LoudRefSig	calculate the loudness of the reference sinusoid (1 kHz, 40 dB HL)

% factor of 100 corresponds to 40 dB:
vAmpRef = db(40:10:70);
FFreqRef = 1000;	% 1000 Hz
% duration in s
FChLen = 1;
% sampling frequency
FSamp = 44100;

% alpha factor
alfa = 1;	% Should not be changed!
alfacorfq =	[0, FSamp/2]';
alfacor =	[alfa, alfa]';

% hearing threshold (in terms of dB HL)
vThrFre =	[1,	125,	250,	500,	750,	1000,	1500,	2000,	3000,	4000,	6000,	8000,	�*�Y��q����OI��w�����1��u6��S{�i֭Ye<�f�\[��8l�+{vy�5/�|��p�D�YQ_��1�X���V�2�I��k����y�g��ٌ$���3�xqh�9�d*���ڴ�s%.22H/�������7��*1�t� ��67��Bm�$NŁ�����l$3�
!ᕙr��B3�x�Q�9J�X/���,uT���S9Kt�=����ѷ���://�>p^7�#����m���N7v�v�~̌�)шZ+-4e)|Y�,`��
d�����[#B�i�{��J�8B.��o_*/��-ػ�e��R;��2?�=if�������.�lrq��$P� 3U�#�����Ƨs����Da氚@cY��	H�\��%Lwn��(c%�*�W;�/�t�^<7�e�&@��C�3�2bQڵ�@�*M���̹�&#��z���^Ta+�G%����I{�+,_L�.�.�����r���y��]֓ݑ�=4�1�y��8��&������n��M�=��q�����H�}����C�0���� ��	�a�%:��~1'̧���΂�D6��4�RXבg?ӭ0ȯ�|�	
A�Ұ�ė�d�]%�%�`�ncx-���.Z��f�T�����N��6= f0/���j�L-�t -|�K�d�66��'�
���ab��C��n�Ŋ(h�=�>85��<��9�ɹደ����������ګ���i�� O]f�Z4oΗn>���^����������� 8�t4N�y��4��%�"ͥwQ~ �&)#�P�c���w�@Ƈވ�ܙ�K���9��P*�'?;�'H�����7���m
�Yv�_��Y����u�N����?Ø�߀Ъ!��7!�m����{ӧ�Hݻ��4��1n�A�����+9�d̓��#�s��|1[�Nj�����{����H���f���<�n�DtC�E��`"�J��pJ��/x�Y������"��dh&��JC&Ė���=]��cl���;T�;?s�m�P�a��wp���Rݤ�2�䔛؄�'��T���5��3�?F��!'�|���ΖE�K	�� 6��@B����3`�,�9�MM�ۈ�q
�Qｾ�
{�HX���T����B���~C@b2���P̭F'�@!��홿b�Fz��(��Dϴ~�k [�g���ȏT	�@i�k�K��a\,U���F��!,�Dk0���j�8+�f�u<~!9(>���m��+��_��-*L���M��א`v�^"�+���u�SpK��n�`�mo��[<^�/.�E�/��/�6�{�
-�T����X��c;ʫU�
hZ��\�lL�N=�v����)��=��dES����"5���AJ��l��X��_�T�XG����bO�4&�qWm�3j`��ֳp�tW�!z�X���m���j<	�H�ut�}�0�a�H�\�vL��c1-+'��[U�+d4�D�"4�ޣ�R�b�%�j@x������,"}�8��Rvװ�i�~�t�^�F�����0�@���C���%�*$nh����w�n4QJc���|X�Wp�D��
Q��X�_
���v��Ѣ�-?�� ߋ\Q6kbz�;Ԃ��=�����5މ���iS�\