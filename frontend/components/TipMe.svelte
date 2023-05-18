<script>
    import { useWallet, useTransfer } from "@connect2ic/svelte"
    const [wallet] = useWallet()
	const [transfer] = useTransfer({
		to: "ujatm-5r4hr-uifzb-2e7mc-ju2le-lbg2e-bu64k-xqy7o-cvimk-2nzky-4qe",
		amount: Number(0.1),
	})

  	const onPurchase = async () => {
    	const { height } = await transfer();
  	}

</script>
{#if $wallet}
<button class="connect-button" on:click={onPurchase}>Buy me some Cycles</button>
{/if}
