<!-- Copyright (C) 2012-2024 Zammad Foundation, https://zammad-foundation.org/ -->

<script setup lang="ts"></script>

<template>
  <div class="flex grow cursor-pointer gap-2 rounded-md px-2 py-3">
    <CommonIcon
      name="x-lg"
      size="small"
      class="shrink-0 text-red-500"
      decorative
    />

    <CommonLabel
      v-tooltip="$t('You have insufficient rights to open this tab.')"
      class="block truncate text-gray-300 dark:text-neutral-400"
    >
      {{ $t('Access denied') }}
    </CommonLabel>
  </div>
</template>

<style scoped>
.draggable span {
  @apply text-neutral-400;
}
</style>
