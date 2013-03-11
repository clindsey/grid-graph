/*
  Base.js
  Copyright 2006-2010, Dean Edwards
  License: http://www.opensource.org/licenses/mit-license.php
*/
var Base=function(){if(arguments.length)this==window?Base.prototype.extend.call(arguments[0],arguments.callee.prototype):this.extend(arguments[0])};Base.version="1.0.2"; Base.prototype={extend:function(b,d){var g=Base.prototype.extend;if(arguments.length==2){var e=this[b],h=this.constructor?this.constructor.prototype:null;if(e instanceof Function&&d instanceof Function&&e.valueOf()!=d.valueOf()&&/\bbase\b/.test(d)){var a=d;d=function(){var k=this.base,l=this;this.base=e;this.baseClass=h;var m=a.apply(this,arguments);this.base=k;this.baseClass=l;return m};d.valueOf=function(){return a};d.toString=function(){return String(a)}}return this[b]=d}else if(b){var i={toSource:null}, c=["toString","valueOf"];if(Base._prototyping)c[2]="constructor";for(var j=0;f=c[j];j++)b[f]!=i[f]&&g.call(this,f,b[f]);for(var f in b)i[f]||g.call(this,f,b[f])}return this},base:function(){}}; Base.extend=function(b,d){var g=Base.prototype.extend;b||(b={});Base._prototyping=true;var e=new this;g.call(e,b);var h=e.constructor;e.constructor=this;delete Base._prototyping;var a=function(){Base._prototyping||h.apply(this,arguments);this.constructor=a};a.prototype=e;a.extend=this.extend;a.implement=this.implement;a.create=this.create;a.getClassName=this.getClassName;a.toString=function(){return String(h)};a.isInstance=function(c){return typeof c!="undefined"&&c!==null&&c.constructor&&c.constructor.__ancestors&& c.constructor.__ancestors[a.getClassName()]};g.call(a,d);b=h?a:e;b.init instanceof Function&&b.init();if(!a.__ancestors){a.__ancestors={};a.__ancestors[a.getClassName()]=true;var i=function(c){if(c.prototype&&c.prototype.constructor&&c.prototype.constructor.getClassName){a.__ancestors[c.prototype.constructor.getClassName()]=true;i(c.prototype.constructor)}};i(a)}if(a.getClassName)b.className=a.getClassName();return b};Base.implement=function(b){if(b instanceof Function)b=b.prototype;this.prototype.extend(b)}; Base.create=function(){};Base.getClassName=function(){return"Base"};Base.isInstance=function(){};