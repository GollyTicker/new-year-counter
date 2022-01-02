<template>
  <div id="app">
    <div id="svg-container">
      <svg id="main-svg" xmlns="http://www.w3.org/2000/svg">
        <g>
          <Countdown
            :counter="this.heart.counter"
            :path="this.heartPath"
            :offset="this.offset()"
            :scale="this.heart.scale"
          />
        </g>
        <text
          id="new-year"
          dominant-baseline="middle"
          text-anchor="middle"
          :x="screenSize.width / 2"
          :y="screenSize.height / 2"
          :font-size="screenSize.width / 20 + 'px'"
          fill="white"
          :display="textDisplay()"
        >
          🎉 🥳 New Year {{ heart.nextYear }}!! 🥳 🎉
        </text>
      </svg>
    </div>
  </div>
</template>

<script>
import WindowUtils from "./services/WindowUtils.js";
import Countdown from "./components/Countdown.vue";
import anime from "animejs";

const screenSize = {
  width: WindowUtils.getWidth(),
  height: WindowUtils.getHeight(),
};

const screenMin = Math.min(screenSize.width, screenSize.height);

// We compute this information every second, as the timer can be interrupted on smartphones due to
// their lack of background tasks.
function computeNewYearInformation() {
  const currentDateAndTime = new Date();

  const nextYear = currentDateAndTime.getFullYear() + 1;
  const newYearStart = new Date("January 01, " + nextYear + " 00:00:00");

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
      screenSize: screenSize,
      screenMin: screenMin,
      timer: -1,
      heart: {
        nextYear: 0,
        counter: 1337,
        scale: screenMin / 500,
      },
    };
  },
  components: {
    Countdown,
  },
  mounted: function () {
    this.refreshDataAfterElapsedTime();
  },
  computed: {
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
  },
  methods: {
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
    offset: function () {
      return { x: this.screenSize.width / 2, y: this.screenSize.height / 2 };
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
</style>