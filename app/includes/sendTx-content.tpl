<!-- Sidebar -->
<section class="col-sm-4">
  <wallet-balance-drtv></wallet-balance-drtv>
  <hr />
  <h5 translate="sidebar_TransHistory"> Transaction History: </h5>
  <ul class="account-info" ng-show="ajaxReq.type != 'CUS'">
    <li><a href="{{ajaxReq.blockExplorerAddr.replace('[[address]]', wallet.getAddressString())}}" target="_blank">{{ajaxReq.blockExplorerAddr.replace('[[address]]', wallet.getAddressString())}}</a></li>
  </ul>
  <div class="well">
    <p> EthereumClassic is a project to save the original vision of Ethereum. The more donations we receive, the more time we spend creating new features, listening to your feedback, and giving you what you want. </p>
    <a class="btn btn-primary btn-block" ng-click="onDonateClick()">DONATE</a>
    <div class="text-success text-center marg-v-sm"><strong ng-show="tx.donate"> THANK YOU!!! </strong></div>
 </div>
</section>
<!-- / Sidebar -->



<!-- Content -->
<section class="col-sm-8">

  <!-- To Address -->
  <div class="row form-group">
    <h4 class="col-xs-12" translate="SEND_trans">Send Transaction</h4>
    <div class="col-xs-10">
      <label translate="SEND_addr"> To Address: </label>
      <input class="form-control"  type="text" placeholder="0xe9a7e26bf5c05fe3bae272d4c940bd7158611ce9" ng-model="tx.to" ng-class="Validator.isValidAddress(tx.to) ? 'is-valid' : 'is-invalid'"/>
    </div>
    <div class="col-xs-2 address-identicon-container">
      <div class="addressIdenticon" title="Address Indenticon" blockie-address="{{tx.to}}" watch-var="tx.to"></div>
    </div>
    </div>
  <!-- / To Address -->

  <!-- Amount to Send -->
  <label translate="SEND_amount">Amount to Send:</label>
  <div class="input-group">
    <input class="form-control" type="text" placeholder="{{ 'SEND_amount_short' | translate }}" ng-model="tx.value" ng-disabled="tx.readOnly" ng-class="Validator.isPositiveNumber(tx.value) ? 'is-valid' : 'is-invalid'"/>
    <div class="input-group-btn">
      <a class="btn btn-default dropdown-toggle" class="dropdown-toggle" ng-click="dropdownAmount = !dropdownAmount" ng-class="dropdownEnabled ? '' : 'disabled'">
        {{unitReadable}}<i class="caret"></i>
      </a>
      <ul class="dropdown-menu dropdown-menu-right" ng-show="dropdownAmount && !tx.readOnly">
        <li><a ng-class="{true:'active'}[tx.sendMode=='ether']" ng-click="setSendMode('ether')">{{ajaxReq.type}}</a></li>
        <li ng-repeat="token in wallet.tokenObjs track by $index" ng-show="token.balance!=0 && token.balance!='loading' || token.type!=='default' || tokenVisibility=='shown'">
          <a ng-class="{true:'active'}[unitReadable == token.getSymbol()]" ng-click="setSendMode('token', $index, token.getSymbol())"> {{token.getSymbol()}} </a>
        </li>

      </ul>
    </div>
  </div>
  <p><a ng-click="transferAllBalance()" ng-hide="tx.readOnly"><span class="strong" translate="SEND_TransferTotal">Send Entire Balance</span></a></p>
  <!-- / Amount to Send -->

  <!-- Gas -->
  <label translate="TRANS_gas"> Gas: </label>
  <input class="form-control" type="text" placeholder="21000" ng-model="tx.gasLimit" ng-class="Validator.isPositiveNumber(tx.gasLimit) ? 'is-valid' : 'is-invalid'"/>
  <!-- / Gas -->

  <!-- Advanced Option Panel -->
  <div ng-show="tx.sendMode=='ether'">
    <a ng-click="showAdvance=!showAdvance">
      <p class="strong" translate="TRANS_advanced"> + Advanced: Add Data </p>
    </a>
    <section ng-show="showAdvance">
      <div class="form-group">
        <label translate="TRANS_data"> Data: </label>
        <input class="form-control" type="text" placeholder="0x6d79657468657277616c6c65742e636f6d20697320746865206265737421" ng-model="tx.data" ng-disabled="tx.readOnly" ng-class="Validator.isValidHex(tx.data) ? 'is-valid' : 'is-invalid'"/>
      </div>
    </section>
  </div>
  <!-- / Advanced Option Panel -->

  <div class="form-group">
    <a class="btn btn-info btn-block" ng-click="generateTx()" translate="SEND_generate"> Generate Transaction </a>
  </div>
  <div class="form-group" ng-show="showRaw">
    <label translate="SEND_raw"> Raw Transaction </label>
    <textarea class="form-control" rows="4" readonly >{{rawTx}}</textarea>
    <label translate="SEND_signed"> Signed Transaction </label>
    <textarea class="form-control" rows="4" readonly >{{signedTx}}</textarea>
  </div>

  <div class="form-group" ng-show="showRaw">
    <a class="btn btn-primary btn-block" data-toggle="modal" data-target="#sendTransaction" translate="SEND_trans"> Send Transaction </a>
  </div>


</section>
<!-- / Content -->
