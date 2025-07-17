"use strict";
(wx["webpackJsonp"] = wx["webpackJsonp"] || []).push([["components/xr-ar-golden-egg/index"],{

/***/ "./src/components/xr-ar-golden-egg/index.js":
/*!**************************************************!*\
  !*** ./src/components/xr-ar-golden-egg/index.js ***!
  \**************************************************/
/***/ (function(__unused_webpack_module, __unused_webpack___webpack_exports__, __webpack_require__) {

/* harmony import */ var _common_share_behavior__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../common/share-behavior */ "./src/components/common/share-behavior.js");
/* harmony import */ var _constants__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../../constants */ "./src/constants/index.js");
/* eslint-disable no-undef */



// eslint-disable-next-line no-undef
Component({
  behaviors: [_common_share_behavior__WEBPACK_IMPORTED_MODULE_0__["default"]],
  properties: {},
  data: {
    loaded: false,
    arReady: false,
    markerMatch: false
  },
  lifetimes: {
    attached: function attached() {
      this.executed = false;
    }
  },
  methods: {
    handleReady: function handleReady(_ref) {
      var detail = _ref.detail;
      var xrScene = this.scene = detail.value;
      this.mat = new (wx.getXrFrameSystem().Matrix4)();
      console.log("xr-scene", xrScene);
    },
    handleAssetsLoaded: function handleAssetsLoaded() {
      this.setData({
        loaded: true
      });
    },
    handleARReady: function handleARReady() {
      var _this = this;
      var xr = wx.getXrFrameSystem();

      // shadow root
      this.root = this.scene.getElementById("root");

      // 动态创建添加tracker
      var lockTrackerEl = this.scene.createElement(xr.XRNode);
      lockTrackerEl.addComponent(xr.ARTracker, {
        mode: "Marker",
        src: _constants__WEBPACK_IMPORTED_MODULE_1__.MARKER_IMAGEEGG
      });
      this.root.addChild(lockTrackerEl);
      var waiting = false;
      lockTrackerEl.event.add("ar-tracker-state", function (tracker) {
        // 获取当前状态和错误信息
        var state = tracker.state;
        if (state === 2 && !waiting) {
          waiting = true;
          // 识别成功后切换到世界坐标

          // 延时保证坐标已经设置
          setTimeout(function () {
            _this.setData({
              markerMatch: true
            });

            // 去除tracker监听
            _this.root.removeChild(lockTrackerEl);
            _this.scene.event.addOnce("touchstart", _this.placeNode.bind(_this));

            // toast
            wx.showToast({
              title: "识别成功,  请扫描平面放置金蛋!",
              duration: 2000
            });
          }, 30);
        }
      });
    },
    placeNode: function placeNode(event) {
      var _event$touches$ = event.touches[0],
        clientX = _event$touches$.clientX,
        clientY = _event$touches$.clientY;
      var _this$scene = this.scene,
        width = _this$scene.frameWidth,
        height = _this$scene.frameHeight;
      if (clientY / height > 0.8 && clientX / width < 0.2) {
        this.scene.getNodeById("setitem").visible = false;
        this.scene.ar.resetPlane();
      } else {
        this.scene.ar.placeHere("setitem", true);
        this.setData({
          markerMatch: false
        });
      }
    },
    // 点击模型, 只执行一次
    handleTouchModel: function handleTouchModel(_ref2) {
      var _this2 = this;
      var detail = _ref2.detail;
      if (this.executed) return;
      this.executed = true;
      var el = detail.value.target;
      var animator = el.getComponent("animator");
      animator.play("All Animations", {
        speed: 0.5,
        loop: 0,
        direction: "forwards"
      });

      // 延迟2s后, 显示结果
      setTimeout(function () {
        // 动画放结束, 隐藏模型
        _this2.scene.getNodeById("setitem").visible = false;
        _this2.triggerEvent("syncWiningStatus", Math.random() > 0.5 ? true : false);
      }, 2000);
    }
  }
});

/***/ })

},
/******/ function(__webpack_require__) { // webpackRuntimeModules
/******/ var __webpack_exec__ = function(moduleId) { return __webpack_require__(__webpack_require__.s = moduleId); }
/******/ __webpack_require__.O(0, ["common"], function() { return __webpack_exec__("./src/components/xr-ar-golden-egg/index.js"); });
/******/ var __webpack_exports__ = __webpack_require__.O();
/******/ }
]);
//# sourceMappingURL=index.js.map