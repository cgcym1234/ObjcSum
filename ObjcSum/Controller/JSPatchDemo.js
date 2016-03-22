require('JSExport,UIView,UIColor')
/*defineClass 接口 任意替换一个类的方法或新增方法*/
defineClass('JSPatchDemo', {
	handleBtn: function(sender) {
        var tableViewController = JPTableViewController.alloc().init()
        self.navigationController().pushViewController_animated(tableViewController, YES)
	},
	
	registerNativeFunToHtml: function() {
            console.log('JS log');
            var object = require('JSObject').alloc().init();
            
            var view = self.view();
            view.setBackgroundColor(require('UIColor').redColor());
            
            var webview = self.webView();
            console.log(webview);
            var context = webview.valueForKeyPath('documentView.webView.mainFrame.javaScriptContext');
            var string = 'js_share';
            context.setObject_forKeyedSubscript(object,string);
            
            //NewJSObject是在下面动态创建的
            var objectnew = require('NewJSObject').alloc().init();
            if (objectnew) {
                console.log('JStest111');
                console.log(objectnew.test())
            }
            else
            {
                console.log('JStest0000');
            }

            context.setObject_forKeyedSubscript(objectnew,'bbb');
    }
});

defineClass('JPTableViewController : UITableViewController <UIAlertViewDelegate>', {
	dataSource: function() {
		/*通过 -getProp:， -setProp:forKey: 这两个方法给对象添加成员变量。
		 * 实现上用了运行时关联接口 objc_getAssociatedObject() 和 objc_setAssociatedObject() 模拟*/
		var data = self.getProp('data');
		if (data) return data;
		var data = [];
		for (var i = 0; i < 20; i++) {
			data.push("cell from js " + i);
		}
		self.setProp_forKey(data, 'data');
		return data;
	},
	numberOfSectionsInTableView: function(tableView) {
		return 1;
	},
	tableView_numberOfRowsInSection: function(tableView, section) {
		return self.dataSource().count();
	},
	tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
		var cell = tableView.dequeueReusableCellWithIdentifier("cell")
		if (!cell) {
			cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
		}
		cell.textLabel().setText(self.dataSource().objectAtIndex(indexPath.row()))
		return cell
	},
	tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
		return 60
	},
	tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
		var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Alert", self.dataSource().objectAtIndex(indexPath.row()), self, "OK", null);
		alertView.show()
	},
	alertView_willDismissWithButtonIndex: function(alertView, idx) {
		console.log('click btn ' + alertView.buttonTitleAtIndex(idx).toJS())
	}
});


defineProtocol('JPDemoProtocol',{
               test: {
               paramsType:"",
               returnType:"",
               },
})


defineClass('NewJSObject:NSObject<JPDemoProtocol>', {
            test: function() {
            console.log('JS New log');
            
            }
})


