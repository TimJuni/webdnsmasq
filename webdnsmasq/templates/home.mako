# -*- coding: utf-8 -*- 
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>${project}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
    <link href="https://gitcdn.github.io/bootstrap-toggle/2.2.0/css/bootstrap-toggle.min.css" rel="stylesheet">
    
  </head>
  <body>
	<br>
	  <div class=container>

      <div class="col-sm-6 col-sm-offset-3">
        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title">Preferences</h3>
          </div>
          <div class="panel-body">
            <form action="save" method="POST" class="form-horizontal">
              % for item in addresses:
                <div class="form-group">
                  <label for="${item}" class="col-xs-8">${item}</label>
                  <div class="col-xs-4">            
                    <input data-toggle="toggle" ${'checked' if addresses[item] else ''} type="checkbox" id="${item}" name="${item}" data-onstyle="success"> 
                  </div>
                </div>
              % endfor
              % for item in servers:
                <div class="form-group">
                  <label for="${item}" class="col-xs-8">${item}</label>
                  <div class="col-xs-4">            
                    <input data-toggle="toggle" ${'checked' if servers[item] else ''} type="checkbox" id="${item}" name="${item}" data-onstyle="danger"> 
                  </div>
                </div>
              % endfor
              
              <div class="form-group">
                <div class="col-xs-12">
                  <button type="submit" class="btn btn-primary">Save</button>
                </div>
              </div>
            </form> 
          </div>
        </div>
      </div>       
	  </div>
	

    <script src="http://code.jquery.com/jquery.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

    <script src="https://gitcdn.github.io/bootstrap-toggle/2.2.0/js/bootstrap-toggle.min.js"></script>
  </body>
</html>
