<template>
  <div id="app">
    <div id="svg-container">
      <svg id="main-svg" xmlns="http://www.w3.org/2000/svg">
        <g>
          <Countdown
            :counter="this.heart.counter"
            :path="this.heartPath"
            :offset="this.offset"
            :scale="this.heartScale"
          />
        </g>
      </svg>
    </div>
    <p
      id="new-year"
      :style="
        'font-size: ' +
        textsize +
        'px;' +
        'top: calc(50% - ' +
        textsize * heightOffsetByScreen +
        'px);' +
        'display:' +
        textDisplay()
      "
    >
      🎉 🥳
      <span v-html="conditionalBreak" />
      Happy
      <span v-html="conditionalBreak" />
      birthday,
      <span v-html="conditionalBreak" />
      Christina!!
      <span v-html="conditionalBreak" />
      🥳 🎉
    </p>
  </div>
</template>

<script>
import WindowUtils from "./services/WindowUtils.js";
import Countdown from "./components/Countdown.vue";
import anime from "animejs";

const testDebug = location.href.includes("test");
const testNewYear = new Date(new Date().getTime() + 5 * 1000);

// We compute this information every second, as the timer can be interrupted on smartphones due to
// their lack of background tasks.
function computeNewYearInformation() {
  const currentDateAndTime = new Date();

  const nextYear = currentDateAndTime.getFullYear() + 1;
  const newYearStart = testDebug
    ? testNewYear
    : new Date("January 01, " + nextYear + " 00:00:00");

  const millisecondsToNewYear = Math.abs(
    newYearStart.getTime() - currentDateAndTime.getTime()
  );
  const secondsToNewYear = Math.round(millisecondsToNewYear / 1000);

  console.log(
    "New Year Info",
    currentDateAndTime,
    nextYear,
    secondsToNewYear,
    millisecondsToNewYear % 1000
  );

  return {
    nextYear: nextYear,
    secondsToNewYear: secondsToNewYear,
    millisToNextSecond: millisecondsToNewYear % 1000,
  };
}

export default {
  name: "App",
  data() {
    return {
      screenSize: {
        height: 10,
        width: 12,
      },
      timer: -1,
      heart: {
        nextYear: 0,
        counter: 1337,
      },
    };
  },
  components: {
    Countdown,
  },
  created() {
    this.updateScreenSize();
  },
  mounted: function () {
    this.refreshDataAfterElapsedTime();
    window.addEventListener("resize", this.windowResized);
  },
  computed: {
    screenMin() {
      return Math.min(this.screenSize.width, this.screenSize.height);
    },
    screenMax() {
      return Math.max(this.screenSize.width, this.screenSize.height);
    },
    textsize() {
      return this.isSlimScreen ? this.screenMax / 25 : this.screenMax / 23;
    },
    heartScale() {
      return this.screenMin / 500;
    },
    heartPath: function () {
      return this.heart.counter <= 0
        ? "M0 200 v-200 h200 a100,100 90 0,1 0,200 a100,100 90 0,1 -200,0z"
        : "";
    },
    heartCountdownRunning: function () {
      return this.heart.counter > 0;
    },
    showText: function () {
      return !this.heartCountdownRunning;
    },
    conditionalBreak() {
      return this.isSlimScreen ? "<br>" : "";
    },
    heightOffsetByScreen() {
      return this.isSlimScreen ? 4.5 : 2;
    },
    offset: function () {
      return { x: this.screenSize.width / 2, y: this.screenSize.height / 2 };
    },
    isSlimScreen() {
      return this.screenSize.height > this.screenSize.width;
    },
  },
  methods: {
    updateScreenSize() {
      this.screenSize.height = WindowUtils.getHeight();
      this.screenSize.width = WindowUtils.getWidth();
    },
    textDisplay: function () {
      if (this.showText) {
        anime
          .timeline({ loop: true })
          .add({
            targets: "#new-year",
            opacity: [0, 1],
            easing: "easeInOutQuad",
            duration: 2500,
          })
          .add({
            targets: "#new-year",
            opacity: 0,
            duration: 1000,
            easing: "easeOutExpo",
            delay: 700,
          });
        return "inline";
      } else {
        return "none";
      }
    },
    windowResized() {
      this.updateScreenSize();
    },
    refreshDataAfterElapsedTime: function () {
      const newYearInfo = computeNewYearInformation();
      // This logic here is needed to ensure, that the timer is properly stopped when the last second is reached.
      if (this.heart.counter == 1) {
        this.heart.counter = 0;
      } else if (this.heartCountdownRunning) {
        this.heart.nextYear = newYearInfo.nextYear;
        this.heart.counter = newYearInfo.secondsToNewYear;
        this.refreshTimerForUntilNextSecond(newYearInfo);
      }
    },
    refreshTimerForUntilNextSecond: function (newYearInfo) {
      clearTimeout(this.timer);
      setTimeout(
        this.refreshDataAfterElapsedTime,
        newYearInfo.millisToNextSecond + 5
      );
    },
  },
};
</script>

<style>
html,
body,
#app,
#svg-container {
  height: calc(100% - 4px);
  width: calc(100% - 4px);
  margin: 0px;
  padding: 0px;
  border: 0px;
  background: black;
}
svg {
  border: black dashed 1px;
  margin: -1px;
  width: 100%;
  height: 100%;
}
#new-year {
  color: white;
  text-align: center;
  position: fixed;
  width: 100%;
}
</style>
