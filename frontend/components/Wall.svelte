<script>
	
	import AllPosts from "./AllPosts.svelte";
	import TopWaves from "./TopWaves.svelte";
	import Header from "./Header.svelte";
	import { useWallet, useTransfer } from "@connect2ic/svelte"
	import logo from "../assets/dfinity.svg"
	const [wallet] = useWallet()
	const [transfer] = useTransfer({
		to: "ujatm-5r4hr-uifzb-2e7mc-ju2le-lbg2e-bu64k-xqy7o-cvimk-2nzky-4qe",
		amount: Number(0.01),
	})

  	const onPurchase = async () => {
    	const { height } = await transfer();
  	}

</script>

<div id="app-container" class="app-container">
	{#if $wallet}
		<TopWaves />
		<Header />
	{/if}

	<section>
		<div class="container">
			<main>
				{#if !$wallet}
				
				<header class="App-header">
					<img src={logo} class="App-logo" alt="logo" />
					<p class="slogan">
					  Every student Needs to vent. Do yours.
					</p>
					connect your wallet, or enter as a guest
				  </header>
				{:else}
					<AllPosts />

					<p>Buy me a beer</p>
				    <button class="connect-button" on:click={onPurchase}>Purchase</button>

				{/if}
			</main>
		</div>
	</section>
</div>

<style>
	.container {
        max-width: 1000px;
        margin: 0 auto;
    }

	section .container {
		display: flex;
		flex-direction: row;
	}
	section .container main {
		flex-grow: 3;
		flex-basis: 600px;
		margin-left: 20px;
	}
</style>