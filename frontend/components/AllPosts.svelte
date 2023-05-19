<script>
    import Post from "./Post.svelte";
    import Profile from "./Profile.svelte";
    import NewPost from "./NewPost.svelte";

    import { useCanister } from "@connect2ic/svelte"

    const [studentwall, { loading }] = useCanister("studentwall")

    let allPosts;
    let myHandle;

    const refresh = async () => {
        console.log("refresh");
        allPosts = await $studentwall.getAllMessagesRanked();
    };
    
    $: {
        if (!$loading && $studentwall) {
            console.log("refreshing");
            refresh();
        }
    };

    function handleChildEvent() {
        refresh();
    };

</script>
<Profile myHandle = "{myHandle}" />
<NewPost on:callback={handleChildEvent}/>

<div class = "all-posts" >
    {#if !allPosts || $loading}
        <div class = "loader"> Loading...</div>
    {:else}
        {#each allPosts as post (post.id) }
            <Post {...post} />
        {/each}
    {/if}
</div>
<style>
    .loader{
        font-size: x-small;
        padding-top: 20px;
        opacity: 0.6;
    }
</style>