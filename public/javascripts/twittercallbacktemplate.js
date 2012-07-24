/* Based on code from http://www.soccio.it/michelinux/2007/11/09/clickable-links-in-twitter-htmljs-badge/en/ */

/*
Copyright (c) 2008, Michele Costantino Soccio. All rights reserved.
Copyright (c) 2008, Alan Hogan. All rights reserved.
 
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

function twitterCallback_withOptions(obj, divid, username, linksinnewwindows, includetimestamp) {
	var wwwregular = /\bwww\.\w.\w/ig;
	var regular = /((https?|s?ftp|ssh)\:\/\/[^"\s\<\>]*[^.,;'">\:\s\<\>\)\]\!])/g;
	var atregular = /\B@([_a-z0-9]+)/ig;
	var twitters = obj;
	var statusHTML = "";
	
	for (var i=0; i<twitters.length; i++) {
		var posttext = "";
		posttext = twitters[i].text.replace(wwwregular, 'http://$&');
		posttext = posttext.replace(regular, '<a href="$1">$1</a>');
		posttext = posttext.replace(atregular, '@<a href="http://twitter.com/$1">$1</a>');
		
		statusHTML += ('<li><span>'+posttext+'</span>');
		if (includetimestamp) {
			statusHTML += (' <a style="font-size:85%" href="http://twitter.com/'+username+'/status/'+twitters[i].id_str+'" title="Tweet 固定链接">'+relative_time(twitters[i].created_at)+'</a>');
		}
		statusHTML += ('</li>');
	}
	
	var twitterupdatelist = document.createElement('ul');
	twitterupdatelist.innerHTML = statusHTML;
	
	if (linksinnewwindows)
	{
		var m = twitterupdatelist.getElementsByTagName("A");
		for (var i=0; i<m.length; i++) {
			m[i].target = "_blank";
		}
	}
	
	var twitterupdatediv = document.getElementById(divid);
	twitterupdatediv.appendChild(twitterupdatelist);
}

function relative_time(time_value) {
	var values = time_value.split(" ");
	time_value = values[1] + " " + values[2] + ", " + values[5] + " " + values[3];
	var parsed_date = Date.parse(time_value);
	var relative_to = (arguments.length > 1) ? arguments[1] : new Date();
	var delta = parseInt((relative_to.getTime() - parsed_date) / 1000);
	delta = delta + (relative_to.getTimezoneOffset() * 60);
	    
	if (delta < 60) {
		return '少于一分钟之前';
	} else if(delta < 90) {
		return '大约一分钟之前';
	} else if(delta < (60*60)) {
		var d = Math.round(parseFloat(delta / 60)).toString();
		return  '%d 分钟之前'.replace('%d', d);
	} else if(delta < (90*60)) {
		return '大约一小时之前';
	} else if(delta < (24*60*60)) {
		var d = Math.round(parseFloat(delta / 3600)).toString();
		return '大约 %d 小时之前'.replace('%d', d);
	} else if(delta < (36*60*60)) {
		return '1 天之前';
	} else {
		var d = Math.round(parseFloat(delta / 86400)).toString();
		return  '%d 天之前'.replace('%d', d);
	}
}
