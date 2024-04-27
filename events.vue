<template>
    <v-row>
        <v-col cols="4" sm="4">
            <!-- <v-list lines="one">
                <v-list-item v-for="n in 3" :key="n" :title="'Item ' + n"
                    subtitle="Lorem ipsum dolor sit amet consectetur adipisicing elit"></v-list-item>
            </v-list> -->

            <v-div>

                <h2>All Events (100)</h2>
                <!-- <v-div style="width: 300px;">
                    <v-tabs v-model="tab" align-tabs="start" style="width: 300px; border-radius: 10px ">

                        <v-tab style="width: 20px;">
                            <p class="v-tab-text">All</p>
                        </v-tab>
                        <v-tab style="width: 20px;">
                            <p class="v-tab-text">Approved</p>
                        </v-tab>
                        <v-tab style="width: 20px;">
                            <p class="v-tab-text">Inactive</p>
                        </v-tab>
                        <v-tab style="width: 20px;">
                            <p class="v-tab-text">Declined</p>
                        </v-tab>
                    </v-tabs></v-div> -->
                <v-card>
                    <v-tabs v-model="tab">
                        <v-tab value="one">
                            <p class="v-tab-text">All</p>
                        </v-tab>
                        <v-tab value="two" class="v-tab-text">
                            <p class="v-tab-text">Approved</p>
                        </v-tab>
                        <v-tab value="three" class="v-tab-text">
                            <p class="v-tab-text">Inactive</p>
                        </v-tab>
                        <v-tab value="four" class="v-tab-text">
                            <p class="v-tab-text">Declined</p>
                        </v-tab>

                    </v-tabs>

                    <v-card-text>
                        <v-window v-model="tab">
                            <v-window-item value="one">
                                One
                            </v-window-item>

                            <v-window-item value="two">
                                Two
                            </v-window-item>

                            <v-window-item value="three">
                                Three
                            </v-window-item>

                            <v-window-item value="four">
                                Four
                            </v-window-item>

                            <v-window-item value="five">
                                Five
                            </v-window-item>
                        </v-window>
                    </v-card-text>
                </v-card>

            </v-div>
            <v-list>
                <!-- Active Item -->
                <v-list-item :class="{ 'active-item': isActive }">
                    <v-list-item-content>
                        <v-list-item-title>Active Item</v-list-item-title>
                    </v-list-item-content>
                </v-list-item>

                <!-- Pending Item -->
                <v-list-item :class="{ 'pending-item': isPending }">
                    <v-list-item-content>
                        <v-list-item-title>Pending Item</v-list-item-title>
                    </v-list-item-content>
                </v-list-item>

                <!-- Inactive Item -->
                <v-list-item :class="{ 'inactive-item': isInactive }">
                    <v-list-item-content>
                        <v-list-item-title>Inactive Item</v-list-item-title>
                    </v-list-item-content>
                </v-list-item>

                <!-- Declined Item -->
                <v-list-item :class="{ 'declined-item': isDeclined }">
                    <v-list-item-content>
                        <v-list-item-title>Declined Item</v-list-item-title>
                    </v-list-item-content>
                </v-list-item>
            </v-list>




        </v-col>

        <v-col cols="12" sm="6">

            <v-table fixed-header height="300px">
                <thead>
                    <tr>
                        <th class="text-left">
                            Name
                        </th>
                        <th class="text-left">
                            Calories
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in desserts" :key="item.name">
                        <td>{{ item.name }}</td>
                        <td>{{ item.calories }}</td>
                    </tr>
                </tbody>
            </v-table>
        </v-col>
    </v-row>
</template>
<script>


export default {

    name: 'Events',

    data() {
        return {
            isActive: true,
            isPending: false,
            isInactive: false,
            isDeclined: false,

            desserts: [
                {
                    name: 'Frozen Yogurt',
                    calories: 159,
                },
                {
                    name: 'Ice cream sandwich',
                    calories: 237,
                },
                {
                    name: 'Eclair',
                    calories: 262,
                },
                {
                    name: 'Cupcake',
                    calories: 305,
                },
                {
                    name: 'Gingerbread',
                    calories: 356,
                },
                {
                    name: 'Jelly bean',
                    calories: 375,
                },
                {
                    name: 'Lollipop',
                    calories: 392,
                },
                {
                    name: 'Honeycomb',
                    calories: 408,
                },
                {
                    name: 'Donut',
                    calories: 452,
                },
                {
                    name: 'KitKat',
                    calories: 518,
                },
            ],
        }
    },
}
</script>
<style>
.active-item {
    border-left: 6px solid green;
    border-radius: 0px;
}

.pending-item {
    border-left: 5px solid orange;

}

.inactive-item {
    border-left: 5px solid gray;
}

.declined-item {
    border-left: 5px solid red;
}

.v-tab-text {
    font-family: 'Poppins', sans-serif;
    font-weight: 400;
    text-align: left;
    font-size: 0.6rem;
}

.v-tab {

    v-tab {
        v-btn {
            height: var(--v-tabs-height);
            border-radius: 0;
            min-width: 80px;
            padding: 4px;
        }
    }
}
</style>
