natd_ctrl
=========

Control configure for nat router aka internet sharing by command wrapper.
Tested on OS X Lion 10.7.5.

このスクリプトを使う前に、それぞれのインターフェースは設定されていなければなりません。
プライベート側のインターフェースをWifiにする場合は、AD-HOCモードにして、必要なIPアドレスを指定してください。
また、ネットワークインタフェースの優先順位を変更して、パブリック側を優先する必要があります。

それらの準備ができたら、コマンドを実行してください。コマンド実行には特権が必要ですので、sudoと併用してください。

nat router を実行する。

$ sudo /path/to/natd_ctrl.sh -n ON

nat routerを止める。

$ sudo /path/to/natd_ctrl.sh -n OFF


スクリプトの中で、プライベート側のインタフェースをen0 (Wi-Fi）、パブリック側のインタフェースを
en2（USB-Ether）で決めうちしています。

これを変更するには、プライベート側を-pで、パブリック側を-wで設定できます。

例）
nat router を実行する。

$ sudo /path/to/natd_ctrl.sh -n ON -p en1 -w en0


