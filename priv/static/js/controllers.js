var app = angular.module('celebrityinn', ['ui.bootstrap']);

app.factory('celebrityinnHomePageService', function ($http) {
	return {		

		getChannelPictures: function (category, count, skip) {
			return $http.get('/api/latestnews/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				return result.data.rows;
			});
		},		
		getImages: function (category, count, skip) {
			return $http.get('/api/imageGallery/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				return result.data.rows;
			});
		},
		getVideo: function (category, count, skip) {
			return $http.get('/api/videos/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				return result.data.rows;
			});

		},
		getInterviews: function (category, count, skip) {
			return $http.get('/api/latestinterviews/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				return result.data.rows;
			});
		}		
	};
});

app.controller('CelebrityinnHome', function ($scope, celebrityinnHomePageService) {
  //the clean and simple way
  $scope.latestVideos     = celebrityinnHomePageService.getVideo('full_composite_article',4,0);
  $scope.imageGallery     = celebrityinnHomePageService.getImages('image_gallery_view',8,0);
  $scope.latestNews 	  = celebrityinnHomePageService.getChannelPictures('media_content',7,0);	
  $scope.latestInterviews = celebrityinnHomePageService.getInterviews('interviews_view',5,0);	
  $scope.currentYear = (new Date).getFullYear();
  //for video player
  	var video = "http://video.contentapi.ws/"+$('#video_val').val() 	
 	// start of code for generating cb,pagetit,pageurl
 	// var vastURI = 'http://vast.optimatic.com/vast/getVast.aspx?id=en732n1l1f3&zone=vpaidtag&pageURL=[INSERT_PAGE_URL]&pageTitle=[INSERT_PAGE_TITLE]&cb=[CACHE_BUSTER]';
	// var vastURI = 'http://ad4.liverail.com/?LR_PUBLISHER_ID=44293&LR_SCHEMA=vast2-vpaid';
	
	$scope.loadVideo = function(){
		$(document).ready(function() {			
			jwplayer('trailor').setup({
                  "flashplayer": "http://player.longtailvideo.com/player.swf",
                  "playlist": [
                    {
                      "file": video
                    }
                  ],
                  "width": 680,
                  "height": 330,
                  stretching: "exactfit",
                  skin: "http://content.longtailvideo.com/skins/glow/glow.zip",
                  autostart: true,
                  "controlbar": {
                    "position": "bottom"
                  },
                  "plugins": {
                  	 "autoPlay": true,
                    "ova-jw": {
                      "ads": {                        
                        "schedule": [
                          {
                            "position": "pre-roll",
                            // "tag": updateURL(vastURI)
                            "tag": "http://ad4.liverail.com/?LR_PUBLISHER_ID=44293&LR_SCHEMA=vast2-vpaid"
                          }
                        ]
                      },
                      "debug": {
                        "levels": "none"
                      }
                    }
                  }
                });
		})
	
	};
});