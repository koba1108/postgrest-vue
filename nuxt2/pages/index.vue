<template>
  <div>
    <div class="table-header">
      <h1>Users</h1>
      <v-btn v-show="!showForm" @click="toggleForm">Create</v-btn>
    </div>
    <div class="create-form" v-show="showForm">
      <v-text-field v-model="name" label="Name" outlined/>
      <v-text-field v-model="email" label="Email" outlined/>
      <v-select v-model="role" :items="roles" label="role"/>
      <div class="actions">
        <v-btn color="primary" @click="createUser">Create</v-btn>
        <v-btn color="secondary" @click="toggleForm">Close</v-btn>
      </div>
    </div>
    <v-data-table
      :headers="headers"
      :items="users"
      :items-per-page="limit"
    >
      <template v-slot:item.actions="{ item }">
        <v-btn color="success" @click="editUser(item)">Edit</v-btn>
        <v-btn color="error" @click="deleteUser(item)">Delete</v-btn>
      </template>
    </v-data-table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showForm: false,
      offset: 0,
      limit: 100,
      headers: [
        { text: 'ID', value: 'id' },
        { text: '名前', value: 'name' },
        { text: 'メールアドレス', value: 'email' },
        { text: '権限', value: 'role' },
        { text: 'アクション', value: 'actions', excludeCol: true },
      ],
      users: [],
      roles: ['ADMIN', 'USER'],
      name: '',
      email: '',
      role: 'USER',
    }
  },
  computed: {
    userCols() {
      return this.headers.filter(h => !h.excludeCol).map((h) => h.value)
    },
  },
  async mounted() {
    await this.$postgrest.$ready
    await this.fetchUsers()
  },
  methods: {
    toggleForm() {
      this.showForm = !this.showForm
    },
    async fetchUsers() {
      const res = await this.$postgrest.users.get({
        select: this.userCols,
        limit: this.limit,
        offset: this.offset,
      })
      this.users = await res.json()
    },
    async createUser() {
      try {
        await this.$postgrest.users.post(
          {}, {}, {
            name: this.name,
            email: this.email,
            role: this.role,
          },
        )
        await this.fetchUsers()
      } catch (e) {
        console.error(e)
      }
    },
    async editUser(user) {
      try {
        await this.$postgrest.users.patch(
          { 'id.eq': user.id }, {}, {
            role: user.role === 'ADMIN' ? 'USER' : 'ADMIN',
          },
        )
        await this.fetchUsers()
      } catch (e) {
        console.error(e)
      }
    },
    async deleteUser(user) {
      try {
        await this.$postgrest.users.delete({
          'id.eq': user.id,
        })
        await this.fetchUsers()
      } catch (e) {
        console.error(e)
      }
    },
  },
}
</script>

<style lang="scss">
.table-header {
  margin: 12px 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.create-form {
  margin: 12px;

  .actions {
    display: flex;
    justify-content: flex-end;

    button {
      margin-left: 12px;
    }
  }
}
</style>
