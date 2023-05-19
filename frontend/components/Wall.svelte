<script>
	
	import AllPosts from "./AllPosts.svelte";
	import TopWaves from "./TopWaves.svelte";
	import Header from "./Header.svelte";
	import { useWallet } from "@connect2ic/svelte"
	import logo from "../assets/dfinity.svg"
	const [wallet] = useWallet();
	import {guest} from '../Stores/Store.js' 

	$:{
	if ($wallet && $guest){
		$guest = false;
		console.log("guest set to false because wallet is not null");
	};
}
</script>

<div id="app-container" class="app-container">
	{#if $wallet || $guest}
		<TopWaves />
		<Header />
	{/if}

	<section>
		<div class="container">
			<main>
				{#if !$wallet && !$guest}
				
				<header class="App-header">
					<img src={logo} class="App-logo" alt="logo" />
					<p class="slogan">
					  Every student needs to vent. Do yours.
					</p>
					connect your wallet, or type your name and enter as a guest
				  </header>
				{:else}
					<AllPosts />
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