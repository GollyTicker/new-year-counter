<template>
  <g :transform="'translate(' + offset.x + ',' + offset.y + ')'">
    <text
      v-bind:x="0"
      v-bind:y="0"
      :font-size="100 * scale * 0.8"
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
        <path id="heart" v-bind:d="this.path" />
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
<style scoped>
#heart {
  fill: rgba(231, 161, 32, 0.979);
}
</style>
