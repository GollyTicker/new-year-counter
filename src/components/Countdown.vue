<template>
  <g :transform="'translate(' + offset.x + ',' + offset.y + ')'">
    <text
      v-bind:x="0"
      v-bind:y="0"
      :font-size="100 * scale"
      v-if="counter > 0"
      fill="white"
      dominant-baseline="middle"
      text-anchor="middle"
    >
      {{ counter }}
    </text>

    <g :transform="'scale(' + scale + ')'">
      <g
        id="heart"
        transform="translate(-100, -75)
        rotate(225, 100, 100)"
      >
        <path id="heart" fill="#B00" v-bind:d="this.path" />
      </g>
    </g>
  </g>
</template>
<script>
export default {
  // eslint-disable-next-line
  name: "Countdown",
  props: ["counter", "path", "offset", "scale"],
};
</script>
